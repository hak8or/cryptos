class StaticpagesController < ApplicationController
  def homepage
  	require 'net/http'

    @last_asset = TimedAsset.last

    @BTC_USD_VALUE = TimedAsset.last.BTC
    @LTC_USD_VALUE = TimedAsset.last.LTC
    @AsicMiner = TimedAsset.last.AsicMiner
    @AsicMiner_small = TimedAsset.last.AsicMiner_small
    @Advanced_Mining_Corp = TimedAsset.last.Advanced_Mining_Corp
    @assets_in_BTC = get_btc_in_assets

    gon.user_info = UserInfo.last

    #     !!!!!!!! PLUCK GIVES YOU AN UNORDERED LIST !!!!!!!!
    # 720 minutes is 12 hours, causing line chart to dislay 12 hours of data.
    # https://groups.google.com/forum/#!topic/rubyonrails-talk/a8EGtT16qiI
    gon.short_BTC_prices = TimedAsset.order("id desc").limit(720).pluck(:BTC, :time_changed)

    # gon.short_assets = TimedAsset.last(30)
    # gon.short_assets = FiveminuteTimedAsset.last(30)
    # gon.short_assets = ThirtyminuteTimedAsset.last(30)
    # gon.short_assets = TwohoursTimedAsset.last(30)
    gon.short_assets = SixhoursTimedAsset.last(35)
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
			(user_info.LTC * TimedAsset.last.LTC) + 
			(user_info.PPC * TimedAsset.last.PPC) +
			(user_info.NMC * TimedAsset.last.NMC) +
			(user_info.XPM * TimedAsset.last.XPM) +
			(user_info.AsicMiner * TimedAsset.last.AsicMiner) +
			(user_info.AsicMiner_small * TimedAsset.last.AsicMiner_small) +
			(user_info.Advanced_Mining_Corp * TimedAsset.last.Advanced_Mining_Corp)

  	return btc_asset_amount
  end

end
