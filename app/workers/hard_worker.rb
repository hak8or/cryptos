class HardWorker
	include Sidekiq::Worker
	require 'net/http'

	def perform()
		i = 0
		while i != 1
			puts "1 minute asset fetch V06    " + Time.now.to_s + "  Row: " + TimedAsset.count.to_s

			another_row = TimedAsset.new(
				:BTC => MTGOX_USD("BTC"),
				:LTC => BTC_E("LTC"),
				:PPC => BTC_E("PPC"),
				:NMC => BTC_E("NMC"),
				:XPM => 0.004,
				:AsicMiner => BTCT_BTC("ASICMINER-PT"),
				:AsicMiner_small => BTCT_BTC("TAT.ASICMINER"),
				:Advanced_Mining_Corp => BTCT_BTC("AMC-PT"),
				:misc1 => 0,
				:misc2 => 0,
				:misc3 => 0,
				:comment => "HardWorker did this",
				:time_changed => Time.now
			)
			another_row.save
			
			sleep 60
		end
	end

	def BTCT_BTC(asset)
		url = "https://btct.co/api/ticker/" + asset.to_s
		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)
		return result['last_price']
	end

	def BTC_E_USD(cryptocurrency)
		url = case cryptocurrency
			when "BTC" then
				"https://btc-e.com/api/2/btc_usd/ticker"
			when "LTC" then
				"https://btc-e.com/api/2/ltc_usd/ticker"
		end

		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)
		return result['ticker']['last']
	end

	def BTC_E(cryptocurrency)
		sleep 0.1
		url = case cryptocurrency
			when "BTC" then
				"https://btc-e.com/api/2/btc_usd/ticker"
			else
				"https://btc-e.com/api/2/" + cryptocurrency.downcase + "_btc/ticker"
		end

		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)
		return result['ticker']['last']
	end

	# No need for the case since MTGOX currently only has BTC.
	def MTGOX_USD(cryptocurrency)
		url = case cryptocurrency
			when "BTC" then
				"http://data.mtgox.com/api/2/BTCUSD/money/ticker_fast?pretty"
		end

		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)
		return result['data']['last']['value']
	end

	def havlock_BTC(asset)
		url = "https://www.havelockinvestments.com/r/ticker"

		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)

		return result[asset.upcase]['last']
	end
end