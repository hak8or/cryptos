class AverageOldAssets
	include Sidekiq::Worker
	sidekiq_options :retry => false

	# Meant to be run only when the workers fail and I need to nuke the new databases due to invalid data.
	#
	# 				/- What type of averaging are we doing. 5 minutes gets 5 rows and averages them 
	# 				|  together, 30 minutes gets 30 rows and averages them together.
	# 				|
	def perform(minutes = 5)
		# find_in_batches is used because this is going to be run on a memory constrained enviorment.
		# Previously all the rows were thrown into one variable, and we shifted the rows by minutes,
		# resulting in horrific slowdowns when the linux swap file began to take over due to not enough
		# ram.
		TimedAsset.find_in_batches(batch_size: minutes) do |asset_group|
			puts minutes.to_s + " minutes     " + asset_group.last.time_changed.to_s

			case minutes
				when 5
					row = FiveminuteTimedAsset.new( average(asset_group) )
				when 30
					row = ThirtyminuteTimedAsset.new( average(asset_group) )
				when 120
					row = TwohoursTimedAsset.new( average(asset_group) )
				when 360
					row = SixhoursTimedAsset.new( average(asset_group) )
			end # end case

			# Using new and then save instead of create since sidekiq does not seem 
			# to like create. I haven't got a faintest clue why.
			row.save
		end
	end

	private

	# Generates the averages for the table.
	def average(table)
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
			:BTC => (avg_BTC / table.count).round(6),
			:LTC => (avg_LTC / table.count).round(6),
			:PPC => (avg_PPC / table.count).round(6),
			:NMC => (avg_NMC / table.count).round(6),
			:XPM => (avg_XPM / table.count).round(6),
			:AsicMiner => (avg_AsicMiner / table.count).round(6),
			:AsicMiner_small => (avg_AsicMiner_small / table.count).round(6),
			:Advanced_Mining_Corp => (avg_Advanced_Mining_Corp / table.count).round(6),
			:misc1 => 0,
			:misc2 => 0,
			:misc3 => 0,
			:comment => "Average Old Assets did this",
			:time_changed => table.last.time_changed
		}
		
		return row
	end # End average table function

end # End average_old_assets class