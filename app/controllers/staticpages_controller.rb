class StaticpagesController < ApplicationController
  def homepage
  	require 'net/http'

    #----------------------- Homepage asset display  -----------------------
    # Trying to decrease the total quries to the DB by copying latest data to
    # a variable and using that var instead of DB for fetching data.
    asset_values = TimedAsset.last
    asset_quantity = UserInfo.last

    # Holds the asset values for the homepage. This is the initial gon version,
    # meaning it contains what will be displayed upon page load. The latter version
    # is the gon.watch version which is periodically refreshed.
    gon.asset_values_initial = {
      # Homepage coins
      :BTC_price => asset_values.BTC,
      :BTC_value => asset_quantity.BTC,
      :LTC_value => asset_values.LTC * asset_quantity.LTC,
      :PPC_value => asset_values.PPC * asset_quantity.PPC,
      :NMC_value => asset_values.NMC * asset_quantity.NMC,
      :XPM_value => asset_values.XPM * asset_quantity.XPM,
     
      # Homepage investments
      :AsicMiner_value => asset_quantity.AsicMiner * asset_values.AsicMiner,
      :AsicMiner_small_value => asset_quantity.AsicMiner_small * asset_values.AsicMiner_small,
      :Advanced_Mining_Corp_value => asset_quantity.Advanced_Mining_Corp * asset_values.Advanced_Mining_Corp,
     
      # Homepage totals
      :BTC_total_value => get_btc_in_assets(asset_values, asset_quantity),
      :USD_total_value => get_btc_in_assets(asset_values, asset_quantity) * asset_values.BTC,

      # The time when this data was fetched.
      :time_updated => [Time.now.strftime("%I:%M:%S %p")]
    }

    # Same as above but the gon.watch version which gets refreshed periodically.
    gon.watch.asset_values = {
      # Homepage coins
      :BTC_price => asset_values.BTC,
      :BTC_value => asset_quantity.BTC,
      :LTC_value => asset_values.LTC * asset_quantity.LTC,
      :PPC_value => asset_values.PPC * asset_quantity.PPC,
      :NMC_value => asset_values.NMC * asset_quantity.NMC,
      :XPM_value => asset_values.XPM * asset_quantity.XPM,
     
      # Homepage investments
      :AsicMiner_value => asset_quantity.AsicMiner * asset_values.AsicMiner,
      :AsicMiner_small_value => asset_quantity.AsicMiner_small * asset_values.AsicMiner_small,
      :Advanced_Mining_Corp_value => asset_quantity.Advanced_Mining_Corp * asset_values.Advanced_Mining_Corp,
     
      # Homepage totals
      :BTC_total_value => get_btc_in_assets(asset_values, asset_quantity),
      :USD_total_value => get_btc_in_assets(asset_values, asset_quantity) * asset_values.BTC,

      # The time when this data was fetched.
      :time_updated => [Time.now.strftime("%I:%M:%S %p")]
    }
    #----------------------- Homepage asset display  -----------------------

    # Used to calculate what the total USD per asset.
    gon.user_info = UserInfo.last

    #     !!!!!!!! PLUCK GIVES YOU AN UNORDERED LIST !!!!!!!!
    # 720 minutes is 12 hours, causing line chart to dislay 12 hours of data.
    # https://groups.google.com/forum/#!topic/rubyonrails-talk/a8EGtT16qiI
    gon.short_BTC_prices = TimedAsset.order("id desc").limit(720).pluck(:BTC, :time_changed)

    # Data used to display graphs over time for each asset.
      # gon.short_assets = TimedAsset.last(30)
      # gon.short_assets = FiveminuteTimedAsset.last(30)
      # gon.short_assets = ThirtyminuteTimedAsset.last(30)
      # gon.short_assets = TwohoursTimedAsset.last(30)
    gon.short_assets = SixhoursTimedAsset.last(150)

    # Add in the most recent data for the graphs as well.
    gon.short_assets.push(TimedAsset.last)
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

  # Description: Adds up all the assets for the user and returns the amount in BTC.
  #  
  # Input: Quantity of each asset and each asset's value
  # Output: The total worth of all the assets the user has in BTC.
  #  
  #                          /- The value of each asset.
  #                          |            /- The quantity of each asset.
  #                          |            |
  def get_btc_in_assets(asset_values, asset_quantity)
  	btc_asset_amount = asset_quantity.BTC + 
			(asset_quantity.LTC * asset_values.LTC) + 
			(asset_quantity.PPC * asset_values.PPC) +
			(asset_quantity.NMC * asset_values.NMC) +
			(asset_quantity.XPM * asset_values.XPM) +
			(asset_quantity.AsicMiner * asset_values.AsicMiner) +
			(asset_quantity.AsicMiner_small * asset_values.AsicMiner_small) +
			(asset_quantity.Advanced_Mining_Corp * asset_values.Advanced_Mining_Corp)

  	return btc_asset_amount
  end

end
