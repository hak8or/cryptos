json.array!(@user_infos) do |user_info|
  json.extract! user_info, :user, :pass, :BTC, :LTC, :PPC, :NMC, :XPM, :AsicMiner, :AsicMiner_small, :Advanced_Mining_Corp, :misc1, :misc2, :misc3, :comment, :time_changed
  json.url user_info_url(user_info, format: :json)
end
