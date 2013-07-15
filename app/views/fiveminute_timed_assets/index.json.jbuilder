json.array!(@fiveminute_timed_assets) do |fiveminute_timed_asset|
  json.extract! fiveminute_timed_asset, :BTC, :LTC, :PPC, :NMC, :XPM, :AsicMiner, :AsicMiner_small, :Advanced_Mining_Corp, :misc1, :misc2, :misc3, :comment, :time_changed
  json.url fiveminute_timed_asset_url(fiveminute_timed_asset, format: :json)
end
