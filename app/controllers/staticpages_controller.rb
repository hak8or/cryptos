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

  def database
    # Contains the rows which will be displayed in the databse view.
    @one_min_rows = [TimedAsset.first(4), TimedAsset.last(4)]

    @five_min_rows = [FiveminuteTimedAsset.first(4), FiveminuteTimedAsset.last(4)]

    @thirty_min_rows = [ThirtyminuteTimedAsset.first(4), ThirtyminuteTimedAsset.last(4)]

    @two_hour_rows = [TwohoursTimedAsset.first(4), TwohoursTimedAsset.last(4)]

    @six_hour_rows = [SixhoursTimedAsset.first(4), SixhoursTimedAsset.last(4)]
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

  def Setup
    Setup.perform_async

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

end
