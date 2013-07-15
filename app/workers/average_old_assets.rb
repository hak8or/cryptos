class AverageOldAssets
	include Sidekiq::Worker

	# Meant to be run only when the workers fail and I need to nuke the new databases due to invalid data or whatever,
	# NOT for running as a worker all the time like the AverageAssets class.
	def perform
		large_table = TimedAsset.all
		minutes = 30

		# Go through the large table and keep averaging and saving while dropping 
		# averaged rows. Once the large table has less than 5 remaining rows, it 
		# means the table has been averaged, so exit the while loop.
		while large_table.count >= minutes
			puts minutes.to_s + " minutes averaging starting: " + Time.now.to_s

			new_table = large_table.shift(minutes)
			temp_table = average(new_table, minutes)

			case minutes
				when 5
					row = FiveminuteTimedAsset.new(temp_table)
				when 30
					row = ThirtyminuteTimedAsset.new(temp_table)
				when 120
					row = TwohoursTimedAsset.new(temp_table)
				when 360
					row = SixhoursTimedAsset.new(temp_table)
			end # end case

			another_row.save
		end
	end

	private

	# Input - table
	# Generates the averages for the table. The minutes for each table are hardcoded into the function. Fetches data from
	# the main data table known as TimedAssets and makes a moving average for it with newfound averages sent to the 
	# associated table. 
	def average(table, minutes)
		avg_BTC = 0
		avg_LTC = 0
		avg_PPC = 0
		avg_NMC = 0
		avg_XPM = 0
		avg_AsicMiner = 0
		avg_AsicMiner_small = 0
		avg_Advanced_Mining_Corp = 0

		table.each { |single_timed_asset|
			avg_BTC += single_timed_asset.BTC
			avg_LTC += single_timed_asset.LTC
			avg_PPC += single_timed_asset.PPC
			avg_NMC += single_timed_asset.NMC
			avg_XPM += single_timed_asset.XPM
			avg_AsicMiner += single_timed_asset.AsicMiner
			avg_AsicMiner_small += single_timed_asset.AsicMiner_small
			avg_Advanced_Mining_Corp += single_timed_asset.Advanced_Mining_Corp
		}

		row = {
			:BTC => (avg_BTC / minutes).round(6),
			:LTC => (avg_LTC / minutes).round(6),
			:PPC => (avg_PPC / minutes).round(6),
			:NMC => (avg_NMC / minutes).round(6),
			:XPM => (avg_XPM / minutes).round(6),
			:AsicMiner => (avg_AsicMiner / minutes).round(6),
			:AsicMiner_small => (avg_AsicMiner_small / minutes).round(6),
			:Advanced_Mining_Corp => (avg_Advanced_Mining_Corp / minutes).round(6),
			:misc1 => 0,
			:misc2 => 0,
			:misc3 => 0,
			:comment => "First Post!",
			:time_changed => table.last.time_changed
		}
		
		return row
	end # End average table function

end # End average_old_assets class

