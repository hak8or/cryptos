# Sidekiq defers scheduling to other, better suited gems.
# If you want to run a job regularly, here's an example
# of using the 'clockwork' gem to push jobs to Sidekiq
# regularly.

# require boot & environment for a Rails app
require_relative "../config/boot"
require_relative "../config/environment"
require "clockwork"

module Clockwork
  every 1.day, 'Daily Cleaning DB', :at => '00:00' do
    puts "Cleaning averages DBs"
    FiveminuteTimedAsset.destroy_all
    ThirtyminuteTimedAsset.destroy_all
    TwohoursTimedAsset.destroy_all
    SixhoursTimedAsset.destroy_all
    puts "Done cleaning averages DBs"

    AverageOldAssets.perform_async(5)
    AverageOldAssets.perform_async(30)
    AverageOldAssets.perform_async(120)
    AverageOldAssets.perform_async(360)
  end

  every 1.minute, '1 minute fetch' do
    HardWorker.perform_async
  end

  every 5.minute, '5 minute average row' do
    AverageAssets.perform_async(5)
  end

  every 30.minute, '30 minute average row' do
    AverageAssets.perform_async(30)
  end

  every 120.minute, '120 minute average row' do
    AverageAssets.perform_async(120)
  end

  every 360.minute, '360 minute average row' do
    AverageAssets.perform_async(360)
  end
end