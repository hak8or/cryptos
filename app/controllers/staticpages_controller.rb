class StaticpagesController < ApplicationController
  def homepage
  	require 'net/http'
  	@assets = TimedAsset.last(500)

    @BTC_USD_VALUE = @assets.last.BTC
    @LTC_USD_VALUE = @assets.last.LTC
    @AsicMiner = @assets.last.AsicMiner
    @AsicMiner_small = @assets.last.AsicMiner_small
    @Advanced_Mining_Corp = @assets.last.Advanced_Mining_Corp
    @assets_in_BTC = get_btc_in_assets
  end

  def about
  end

  def start_log
    HardWorker.perform_async
    AverageAssets.perform_async(5)
    AverageAssets.perform_async(30)
    AverageAssets.perform_async(120)
    AverageAssets.perform_async(360)

    respond_to do |format|
      format.html { redirect_to "/database" }
      format.json { head :no_content }
    end
  end

  def do_old_assets_averaging
    AverageOldAssets.perform_async(5)
    AverageOldAssets.perform_async(30)
    AverageOldAssets.perform_async(120)
    AverageOldAssets.perform_async(360)

    respond_to do |format|
      format.html { redirect_to "/database" }
      format.json { head :no_content }
    end
  end

  def NUKE_Averages
    CleanAveragesDB.perform_async

    respond_to do |format|
      format.html { redirect_to "/database" }
      format.json { head :no_content }
    end
  end

  #======================================= PRIVATE =======================================
  private

  def get_btc_in_assets
  	user_info = UserInfo.last
  	
  	btc_asset_amount = user_info.BTC + 
  					(user_info.LTC * @assets.last.LTC) + 
  					(user_info.PPC * @assets.last.PPC) +
  					(user_info.NMC * @assets.last.NMC) +
					(user_info.XPM * @assets.last.XPM) +
					(user_info.AsicMiner * @assets.last.AsicMiner) +
					(user_info.AsicMiner_small * @assets.last.AsicMiner_small) +
					(user_info.Advanced_Mining_Corp * @assets.last.Advanced_Mining_Corp)

  	return btc_asset_amount
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

  def BTC_E(cryptocurrency)
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
end
