# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# When the page fully loads, run the following
$(document).ready ->
  renew_Time = (data) ->
    $('#updated').text("Last updated: " + data)

  display_asset_values = (assets) ->
    # Homepage coins
    $('#BTC_price').text("BTC: $" + assets.BTC_price.toFixed(2))
    $('#BTC_value').text("BTC: " + assets.BTC_value.toFixed(4))
    $('#LTC_value').text("LTC: " + assets.LTC_value.toFixed(4) + " BTC")
    $('#PPC_value').text("PPC: " + assets.PPC_value.toFixed(4) + " BTC")
    $('#NMC_value').text("NMC: " + assets.NMC_value.toFixed(4) + " BTC")
    $('#XPM_value').text("XPM: " + assets.XPM_value.toFixed(4) + " BTC")

    # Homepage investments
    $('#AsicMiner_value').text("AsicMiner: " + assets.AsicMiner_value.toFixed(4) + " BTC")
    $('#AsicMiner_small_value').text("AsicMiner small: " + assets.AsicMiner_small_value.toFixed(4) + " BTC")
    $('#Advanced_Mining_Corp_value').text("Advanced Mining Corp: " + assets.Advanced_Mining_Corp_value.toFixed(4) + " BTC")

    # Homepage totals
    $('#BTC_total_value').text("Total BTC of assets: " + assets.BTC_total_value.toFixed(5) + " BTC")
    $('#USD_total_value').text("Total USD of assets: $" + assets.USD_total_value.toFixed(2))

    # Time this was fetched
    $('#updated').text("Updated: " + assets.time_updated)

  # Refreshes the homepage assets
  #			            /- The gon watch variable name.
  #			            |          /- How often to call the later function in ms.
  #                 |          |                    /- The function to call after previous interval.
  #                 |          |                    |
  gon.watch('asset_values', interval: 10000, display_asset_values)

  # Displays the initial data for the homepage assets when the page loads.
  # gon.watch only runs after the time interval passes instead of immediatly, so this does the
  # exact same as when gon.watch.asset_values refreshes but immediatly instead of waiting first.
  display_asset_values(gon.asset_values_initial)