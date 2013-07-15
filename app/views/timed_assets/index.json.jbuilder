json.array!(@timed_assets) do |timed_asset|
  json.extract! timed_asset, :BTC, :LTC, :PPC, :NMC, :XPM, :AsicMiner, :AsicMiner_small, :Advanced_Mining_Corp, :misc1, :misc2, :misc3, :comment, :time_changed
  json.url timed_asset_url(timed_asset, format: :json)
end
