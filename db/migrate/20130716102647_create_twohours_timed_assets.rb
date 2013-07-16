class CreateTwohoursTimedAssets < ActiveRecord::Migration
  def change
    create_table :twohours_timed_assets do |t|
      t.float :BTC
      t.float :LTC
      t.float :PPC
      t.float :NMC
      t.float :XPM
      t.float :AsicMiner
      t.float :AsicMiner_small
      t.float :Advanced_Mining_Corp
      t.float :misc1
      t.float :misc2
      t.float :misc3
      t.text :comment
      t.datetime :time_changed

      t.timestamps
    end
  end
end
