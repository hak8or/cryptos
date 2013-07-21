class Setup
	include Sidekiq::Worker

	# This is meant to act as a one button solution for starting
	# logging and filling the average tables. If setup is run after
	# being run earlier, restart the fetching/averaging tables and
	# redo the average tables.
	# !!! SIDEKIQ SLOWELY ACCEPTS LARGE AMOUNTS OF JOBS, DELAYS !!!
	def perform
		puts " ------ Initiating Setup!"
		clean_log
		send_massage("log", "Starting setup")

		# Step 1: Stop all possible workers in the default queue.
		clear_workers("ALL")

		# Step 2: Make sure the average tables are clean
		CleanAveragesDB.perform_async

		# Step 3: Fill average tables with appropriate data from 1 minute table
		# 		  only after step 2 is complete.
		wait_for_workers
		AverageOldAssets.perform_async(5)
	    AverageOldAssets.perform_async(30)
	    AverageOldAssets.perform_async(120)
	    AverageOldAssets.perform_async(360)

	    # Step 4: Start the 1 minute data fetch worker after step 3 is done.
	    sleep 10 # Delay to allow the averageoldassets methods to start because
	    		 # Sidekiq seems to have a large delay when adding many workers.
	    wait_for_workers
	    HardWorker.perform_async

	    # Step 5: Start the x minute averaging workers.
	    AverageAssets.perform_async(5)
	    AverageAssets.perform_async(30)
	    AverageAssets.perform_async(120)
	    AverageAssets.perform_async(360)

	    send_massage("log", "Done with Setup")
	    puts " ------ Done with Setup!"
	end

	private

	# Sends a shutdown signal to all workers. Then waits until all workers
	# except this one are shut down. Lastly, it clears the kill signal.
	def clear_workers(target = "ALL")
		# Send shutdown to all workers
		message = Messages.new(
			target: target.to_s.upcase,
			body: "SHUTDOWN",
			from: "Setup Worker",
			misc: ""
		 )
		message.save

		# Wait untill all workers except this are shutdown
		while (Sidekiq::Workers.new).size != 1
			sleep 0.2
			puts "Waiting for workers to shut down ... "
		end

		Messages.where(" target = 'ALL' ").destroy_all
	end

	# Just wait for all workers except this one to finish.
	def wait_for_workers
		# Wait untill all workers except this are shutdown
		while (Sidekiq::Workers.new).size != 1
			sleep 0.2
			puts "Waiting for workers to shut down ... "
		end
	end

	# Sends a message to the massage queue.
	def send_massage(target = "log", message = "no message was given")
		message = Messages.new(
			target: target.to_s.upcase,
			body: message.to_s.upcase,
			from: "Setup Worker",
			misc: ""
		 )
		message.save
	end

	# Cleans the log of everything.
	def clean_log
		Messages.where(" target = 'LOG' ").destroy_all
	end
end