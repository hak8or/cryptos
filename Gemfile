source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# --------------- MY GEMS ----------------------
# Foundation gem for nice website visual layout
gem 'zurb-foundation'

# Sidekiq Gem for handling jobs on the side (Just for logging differences in price over time)
gem 'sidekiq'

# Send Rails variables to JS variables
gem 'gon'

# Gems for monitoring sidekiq
gem 'sinatra', require: false
gem 'slim'

# Gem for better errors and whatnot.
group :development do
	gem "binding_of_caller"
	gem "better_errors"
end

# sqlite3 does not handle concurrent reads and writes well, postresql it is!
gem 'pg'

# ClockWork gem to handle repeated tasks (fetch assets data every minute)
gem 'clockwork'

# TEMPORARY HERE!!! DELETE AFTER MIGRATING DB FROM SQLITE3 TO POSTGRESQL
# https://github.com/ricardochimal/taps/issues/128
# gem 'taps', :git => 'git://github.com/ricardochimal/taps.git'