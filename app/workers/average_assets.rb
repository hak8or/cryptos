class AverageAssets
	include Sidekiq::Worker

	def perform(minutes)
		i = 1
		while i != 0
			puts minutes.to_s + " minutes averaging starting: " + Time.now.to_s + "  Row: " + FiveminuteTimedAsset.count.to_s

			avg_BTC = 0
			avg_LTC = 0
			avg_PPC = 0
			avg_NMC = 0
			avg_XPM = 0
			avg_AsicMiner = 0
			avg_AsicMiner_small = 0
			avg_Advanced_Mining_Corp = 0

			timed_asset_recent = TimedAsset.last(minutes)

			timed_asset_recent.each { |single_timed_asset|
				avg_BTC += single_timed_asset.BTC
				avg_LTC += single_timed_asset.LTC
				avg_PPC += single_timed_asset.PPC
				avg_NMC += single_timed_asset.NMC
				avg_XPM += single_timed_asset.XPM
				avg_AsicMiner += single_timed_asset.AsicMiner
				avg_AsicMiner_small += single_timed_asset.AsicMiner_small
				avg_Advanced_Mining_Corp += single_timed_asset.Advanced_Mining_Corp
			}

			avg_BTC = (avg_BTC / minutes).round(6)
			avg_LTC = (avg_LTC / minutes).round(6)
			avg_PPC = (avg_PPC / minutes).round(6)
			avg_NMC = (avg_NMC / minutes).round(6)
			avg_XPM = (avg_XPM / minutes).round(6)
			avg_AsicMiner = (avg_AsicMiner / minutes).round(6)
			avg_AsicMiner_small = (avg_AsicMiner_small / minutes).round(6)
			avg_Advanced_Mining_Corp = (avg_Advanced_Mining_Corp / minutes).round(6)

			case minutes
			when 5
				another_row = FiveminuteTimedAsset.new(
					:BTC => avg_BTC,
					:LTC => avg_LTC,
					:PPC => avg_PPC,
					:NMC => avg_NMC,
					:XPM => avg_XPM,
					:AsicMiner => avg_AsicMiner,
					:AsicMiner_small => avg_AsicMiner_small,
					:Advanced_Mining_Corp => avg_Advanced_Mining_Corp,
					:misc1 => 0,
					:misc2 => 0,
					:misc3 => 0,
					:comment => "average_assets did this",
					:time_changed => timed_asset_recent.last.time_changed
				)

			when 30
				another_row = ThirtyminuteTimedAsset.new(
					:BTC => avg_BTC,
					:LTC => avg_LTC,
					:PPC => avg_PPC,
					:NMC => avg_NMC,
					:XPM => avg_XPM,
					:AsicMiner => avg_AsicMiner,
					:AsicMiner_small => avg_AsicMiner_small,
					:Advanced_Mining_Corp => avg_Advanced_Mining_Corp,
					:misc1 => 0,
					:misc2 => 0,
					:misc3 => 0,
					:comment => "average_assets did this",
					:time_changed => timed_asset_recent.last.time_changed
				)
			when 120
				another_row = TwohoursTimedAsset.new(
					:BTC => avg_BTC,
					:LTC => avg_LTC,
					:PPC => avg_PPC,
					:NMC => avg_NMC,
					:XPM => avg_XPM,
					:AsicMiner => avg_AsicMiner,
					:AsicMiner_small => avg_AsicMiner_small,
					:Advanced_Mining_Corp => avg_Advanced_Mining_Corp,
					:misc1 => 0,
					:misc2 => 0,
					:misc3 => 0,
					:comment => "average_assets did this",
					:time_changed => timed_asset_recent.last.time_changed
				)
			when 360
				another_row = SixhoursTimedAsset.new(
					:BTC => avg_BTC,
					:LTC => avg_LTC,
					:PPC => avg_PPC,
					:NMC => avg_NMC,
					:XPM => avg_XPM,
					:AsicMiner => avg_AsicMiner,
					:AsicMiner_small => avg_AsicMiner_small,
					:Advanced_Mining_Corp => avg_Advanced_Mining_Corp,
					:misc1 => 0,
					:misc2 => 0,
					:misc3 => 0,
					:comment => "average_assets did this",
					:time_changed => timed_asset_recent.last.time_changed
				)
			end

			another_row.save

			sleep minutes * 60
		end
	end
end

