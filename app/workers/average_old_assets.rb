class AverageOldAssets
	include Sidekiq::Worker
	sidekiq_options :retry => false

	# Meant to be run only when the workers fail and I need to nuke the new databases due to invalid data or whatever,
	# NOT for running as a worker all the time like the AverageAssets class.
	def perform(minutes = 5)
		large_table = TimedAsset.all

		# Go through the large table and keep averaging and saving while dropping 
		# averaged rows. Once the large table has less than 5 remaining rows, it 
		# means the table has been averaged, so exit the while loop.
		until large_table.count < minutes do
			new_table = large_table.shift(minutes)

			if new_table.last.nil?
				break
			end

			puts minutes.to_s + " minutes averaging starting: " + new_table.last.time_changed.to_s

			case minutes
				when 5
					row = FiveminuteTimedAsset.new(average(new_table, minutes))
				when 30
					row = ThirtyminuteTimedAsset.new(average(new_table, minutes))
				when 120
					row = TwohoursTimedAsset.new(average(new_table, minutes))
				when 360
					row = SixhoursTimedAsset.new(average(new_table, minutes))
			end # end case

			# Using new and then save instead of create since sidekiq does not seem 
			# to like create. I haven't got a faintest clue why.
			row.save
		end

		puts "Done generating averages"
	end

	private

	# Generates the averages for the table.
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
			:comment => "Average Old Assets did this",
			:time_changed => table.last.time_changed
		}
		
		return row
	end # End average table function

end # End average_old_assets class