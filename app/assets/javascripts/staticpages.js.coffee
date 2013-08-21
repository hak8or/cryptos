# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# When the page fully loads, run the following
$(document).ready ->
  renew_Time = (data) ->
    $('#updated').text("Last updated: " + data)

  renew_BTC_price = (data) ->
    $('#BTC_price').text("BTC: $" + data.toFixed(2) )

  # Altcoins section
  renew_BTC_value = (data) ->
    $('#BTC_value').text("BTC: " + data.toFixed(4) )  
  renew_LTC_value = (data) ->
  	$('#LTC_value').text("LTC: " + data.toFixed(4) + " BTC")
  renew_PPC_value = (data) ->
  	$('#PPC_value').text("PPC: " + data.toFixed(4) + " BTC")
  renew_NMC_value = (data) ->
  	$('#NMC_value').text("NMC: " + data.toFixed(4) + " BTC")
  renew_XPM_value = (data) ->
  	$('#XPM_value').text("XPM: " + data.toFixed(4) + " BTC")

  # Investments section
  renew_AsicMiner_value = (data) ->
    $('#AsicMiner_value').text("AsicMiner: " + data.toFixed(4) + " BTC")
  renew_AsicMiner_small_value = (data) ->
    $('#AsicMiner_small_value').text("AsicMiner small: " + data.toFixed(4) + " BTC")
  renew_Advanced_Mining_Corp_value = (data) ->
    $('#Advanced_Mining_Corp_value').text("Advanced Mining Corp: " + data.toFixed(4) + " BTC")

  # Totals section
  renew_BTC_total_value = (data) ->
  	$('#BTC_total_value').text("Total BTC of assets: " + data.toFixed(5) + " BTC")
  renew_USD_total_value = (data) ->
  	$('#USD_total_value').text("Total USD of assets: $" + data.toFixed(2))

  #			     /- The gon watch variable name.
  #			     |          /- How often to call the later function in ms.
  #          |          |               /- The function to call after previous interval.
  #          |          |               |
  gon.watch('time', interval: 10000, renew_Time)

  gon.watch('BTC_price', interval: 10000, renew_BTC_price)

  # Altcoins section
  gon.watch('BTC_value', interval: 10000, renew_BTC_value)
  gon.watch('LTC_value', interval: 10000, renew_LTC_value)
  gon.watch('PPC_value', interval: 10000, renew_PPC_value)
  gon.watch('NMC_value', interval: 10000, renew_NMC_value)
  gon.watch('XPM_value', interval: 10000, renew_XPM_value)

  # Investments section
  gon.watch('AsicMiner_value', interval: 10000, renew_AsicMiner_value)
  gon.watch('AsicMiner_small_value', interval: 10000, renew_AsicMiner_small_value)
  gon.watch('Advanced_Mining_Corp_value', interval: 10000, renew_Advanced_Mining_Corp_value)

  # Totals section
  gon.watch('BTC_total_value', interval: 10000, renew_BTC_total_value)
  gon.watch('USD_total_value', interval: 10000, renew_USD_total_value)