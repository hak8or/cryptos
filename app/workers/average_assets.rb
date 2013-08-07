class AverageAssets
	include Sidekiq::Worker

	def perform(minutes = 5)
		puts minutes.to_s + " minutes average: " + Time.now.to_s

		short_table = TimedAsset.last(minutes)

		case minutes
			when 5
				another_row = FiveminuteTimedAsset.new( average(short_table) )
			when 30
				another_row = ThirtyminuteTimedAsset.new( average(short_table) )
			when 120
				another_row = TwohoursTimedAsset.new( average(short_table) )
			when 360
				another_row = SixhoursTimedAsset.new( average(short_table) )
		end
		another_row.save
	end # End perform method

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

end

