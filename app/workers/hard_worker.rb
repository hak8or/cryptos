class HardWorker
	include Sidekiq::Worker
	require 'net/http'

	def perform
		puts "1 minute asset fetch V06    " + Time.now.to_s + "  Row: " + TimedAsset.count.to_s

		another_row = TimedAsset.new(
			:BTC => MTGOX_USD("BTC"),
			:LTC => BTC_E_BTC("LTC"),
			:PPC => BTC_E_BTC("PPC"),
			:NMC => BTC_E_BTC("NMC"),
			:XPM => Vircurex("XPM"),
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
	end
	
	private

	# Returns the how much BTC one unit of cryptocurrency is worth.
	def Vircurex(cryptocurrency)
		url = "https://vircurex.com/api/get_last_trade.json?base=" + 
			cryptocurrency.to_s + "&alt=BTC"
			
		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)
		return result['value']
	end

	# Returns the how much BTC one unit of asset is worth.
	def BTCT_BTC(asset)
		url = "https://btct.co/api/ticker/" + asset.to_s

		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)
		return result['last_price']
	end

	# Returns the how much USD one unit of cryptocurrency is worth.
	def BTC_E_USD(cryptocurrency)
		sleep 0.3
		url = "https://btc-e.com/api/2/" + cryptocurrency.downcase + "_usd/ticker"

		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)
		return result['ticker']['last']
	end

	# Returns the how much BTC one unit of cryptocurrency is worth.
	def BTC_E_BTC(cryptocurrency)
		sleep 0.3
		url = "https://btc-e.com/api/2/" + cryptocurrency.downcase + "_btc/ticker"

		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)
		return result['ticker']['last']
	end

	# Returns the how much USD one unit of cryptocurrency is worth.
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

	# Returns the how much BTC one unit of asset is worth.
	def havlock_BTC(asset)
		url = "https://www.havelockinvestments.com/r/ticker"

		response = Net::HTTP.get_response(URI.parse(url))
		data = response.body
		result = ActiveSupport::JSON.decode(data)

		return result[asset.upcase]['last']
	end
end