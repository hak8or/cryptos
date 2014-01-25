#!/usr/bin/env bash

# ---- Todo in this script ----
# New script for starting up services.
# Add tmuxinator and tmux installation for startup script.

echo "+----------------------------------------------------+"
echo "|  Setup of the cryptos website used to track        |"
echo "|    crypto coin related assets.                     |"
echo "+----------------------------------------------------+"

# Default Rails secret token used for cookies. Only for development!
dev_token=27e7a1c2cc05b7506a1d6bfe8e305a83087789fafb94455b6608178fb1f842bc1470498e6e0c85e490df61236238b7633a8056da7a31ead3c1161dff5227d67a

# When the script gets provisioned on a vagrant box, the current home directory is root,
# which is not what we want. So, if the vagrant option is put in from the vagrantfile then
# this will be installed into /home/vagrant instead of /vagrant/root.
if [[ $1 == "vagrant" ]]; then
    working_directory="/home/vagrant"
else
    working_directory="$HOME"
fi

# Initial values for where to run script and if box was set up using my script.
setup_by_my_script=0
project_directory=$working_directory/cryptos
log_location="$working_directory/setup.log"

# Setup logging file and location which will hold this scripts output.
  mkdir -p $working_directory
  touch $log_location &>>/dev/null
  echo "----FROM SCRIPT ECHO---- Starting Script" &>>$log_location

# Install the required packages
  echo "  [1/5] Installing required packages"
  echo "----FROM SCRIPT ECHO---- Installing required packages" &>>$log_location

  # Install git to download cryptos. Maybe make releases?
  echo "    \ [1/1] git to clone the cryptos git repo"
  echo "----FROM SCRIPT ECHO---- git to clone the cryptos git repo" &>>$log_location
  sudo apt-get install -y git &>>$log_location

# Downloading the github repo section.
  echo "  [2/5] Fetching cryptos git repo"
  echo "----FROM SCRIPT ECHO---- Fetching cryptos git repo" &>>$log_location
  cd $working_directory &>>$log_location

  # If there is an old demo_rails_app back it up and signfy the box was setup
  # using my scripts.
  if [ -d "demo_rails_app" ]; then
    # Since this was setup using my script, it is assumed that the user
    # wants everything to be setup automatically, which requires cryptos
    # to be demo_rails_app.
    echo "    |- NOTE: Found demo_rails_app folder!"
    echo "----FROM SCRIPT ECHO---- NOTE: Found demo_rails_app folder!" &>>$log_location
    project_directory=$working_directory/demo_rails_app
    setup_by_my_script=1

    # Cannot mv since the directory is in use by phusion but phusion is a horrific
    # pain to halt.
    echo "    |- [1/3] Backing demo_rails_app folder up"
    echo "----FROM SCRIPT ECHO---- Backing demo_rails_app folder up" &>>$log_location
    mkdir demo_rails_app.old &>>$log_location
    cp -r demo_rails_app/ demo_rails_app.old/ &>>$log_location
    rm -r -f demo_rails_app/* &>>$log_location

    echo "    |- [2/3] Cloning cryptos git repo"
    echo "----FROM SCRIPT ECHO---- Cloning cryptos git repo" &>>$log_location
    git clone git://github.com/hak8or/cryptos.git &>>$log_location

    echo "    \- [3/3] Moving cryptos into demo_rails_app"
    echo "----FROM SCRIPT ECHO---- Moving cryptos into demo_rails_app" &>>$log_location
    cp -r cryptos/* demo_rails_app/ &>>$log_location
    rm -r -f cryptos &>>$log_location

  else
    echo "    \- [1/1] Cloning cryptos git repo"
    echo "----FROM SCRIPT ECHO---- Cloning cryptos git repo" &>>$log_location
    git clone git://github.com/hak8or/cryptos.git &>>$log_location

  fi

# Install the redis-server used by sidekiq.
  echo "  [3/5] Installing Redis Server"
  echo "----FROM SCRIPT ECHO---- Installing Redis Server" &>>$log_location

  echo "    |- [1/5] Downloading redis tarball"
  echo "----FROM SCRIPT ECHO---- Downloading redis tarball" &>>$log_location
  wget http://download.redis.io/redis-stable.tar.gz &>>$log_location

  echo "    |- [2/5] Extracting redis tarball"
  echo "----FROM SCRIPT ECHO---- Extracting redis tarball" &>>$log_location
  tar xvzf redis-stable.tar.gz &>>$log_location

  echo "    |- [3/5] Compiling redis"
  echo "----FROM SCRIPT ECHO---- Compiling redis" &>>$log_location
  cd redis-stable
  make &>>$log_location

  # Copy redis-server over to bin so you can just run redis-server anywhere.
  echo "    |- [4/5] Copying redis-server and redis-cli"
  echo "----FROM SCRIPT ECHO---- Copying redis-server and redis-cli" &>>$log_location
  sudo cp src/redis-server /usr/local/bin/ &>>$log_location

  # Same but for the CLI (Command Line Interface)
  sudo cp src/redis-cli /usr/local/bin/ &>>$log_location

  # Lets see if redis-server is working correctly.
  # I do not have a good solution for starting processes which take control
  # of the terminal and run forever, so this test is commented out for now.
  # I hope to either try using supervisord for this or just temporarily
  # start and stop it just to tests is redis-server is ok.
    # response=$(redis-cli ping)

    #if [[response -eq "pong"]]
    #  echo "Redis Server working correctly!"
    #else
    #  echo "Redis Server failed to respond with ping."
    #  echo "This means that Redis Server is not working correctly."
    #  exit
    #fi

  # Go back to working directory.
  cd $working_directory &>>$log_location

  # Delete the redis-stable folder and tarbal since we don't need them anymore.
  echo "    \- [5/5] Cleaning up after myself"
  echo "----FROM SCRIPT ECHO---- Cleaning up after myself" &>>$log_location
  rm -r -f redis-stable &>>$log_location
  rm redis-stable.tar.gz &>>$log_location

# Configures the cryptos rails application.
  echo "  [4/5] Setting up Cryptos"
  echo "----FROM SCRIPT ECHO---- Setting up Cryptos" &>>$log_location

  # Add in therubyracer gem as the JS runtime to the Gemfile.
  # Not nodejs since apt-get install nodejs is not seen via phusion
  # for some reason.
  echo "    |- [1/5] Adding therubyracer and rack to gemfile"
  echo "----FROM SCRIPT ECHO---- Adding therubyracer and rack to gemfile" &>>$log_location
  cat <<- _EOF_ >>$project_directory/Gemfile

  gem "therubyracer", :require => 'v8'

  gem "rack"
_EOF_


  # Set up a secret_token.rb for the rails server.
  # Lets make the secret_token.rb file first if it isn't already there.
  echo "    |- [2/5] Setting up secret_token for rails"
  echo "----FROM SCRIPT ECHO---- Setting up secret_token for rails" &>>$log_location
  touch $project_directory/config/initializers/secret_token.rb &>>$log_location

  cat <<- _EOF_ >$project_directory/config/initializers/secret_token.rb
    Cryptos::Application.config.secret_key_base = ENV['SECRET_TOKEN'] || '$dev_token'
_EOF_

  # Change the database.yml credentials if needed.
  if [ $setup_by_my_script -eq 1 ]; then
    echo "    |- [3/5] Changing DB credentials"
    echo "----FROM SCRIPT ECHO---- Changing DB credentials" &>>$log_location
    sudo sed -i 's/database: cryptos_development/database: demo_rails_app_development/g' $project_directory/config/database.yml &>>$log_location
    sudo sed -i 's/database: cryptos_test/database: demo_rails_app_test/g' $project_directory/config/database.yml &>>$log_location
    sudo sed -i 's/database: cryptos/database: demo_rails_app/g' $project_directory/config/database.yml &>>$log_location
    sudo sed -i 's/username: cryptos/username: demo_user/g' $project_directory/config/database.yml &>>$log_location
    sudo sed -i 's/password: pass1/password: pass1/g' $project_directory/config/database.yml &>>$log_location
    sudo sed -i 's/#host: localhost/host: localhost/g' $project_directory/config/database.yml &>>$log_location
  else
    echo "    |- [3/5] Not changing DB credentials" &>>$log_location
    echo "----FROM SCRIPT ECHO---- Not changing DB credentials" &>>$log_location
  fi

  # Run bundle to install all the new gems added earlier.
  echo "    |- [4/5] Bundle to install gems"
  echo "----FROM SCRIPT ECHO---- Bundle to install gems" &>>$log_location
  cd $project_directory &>>$log_location
  sudo bundle install &>>$log_location

  # Generate the DB. db:create does not seem to work anymore, migrate instead is fine.
  echo "    \- [5/5] Making the DB"
  echo "----FROM SCRIPT ECHO---- Making the DB" &>>$log_location
  cd $project_directory &>>$log_location
  sudo bundle exec rake db:migrate &>>$log_location

# Restart the Nginx server to apply changes to database.yml
  echo "  [5/5] Restarting Nginx for changes to take effect"
  echo "----FROM SCRIPT ECHO---- Restarting Nginx for changes to take effect" &>>$log_location
  sudo service nginx restart &>>$log_location

echo "----FROM SCRIPT ECHO---- Script done!" &>>$log_location
echo "+----------------------------------------------------+"
echo "|                     All done!                      |"
echo "|                                                    |"
echo "|  Please begin all the required services!           |"
echo "+----------------------------------------------------+"
