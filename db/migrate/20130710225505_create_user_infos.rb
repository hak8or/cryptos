class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.string :user
      t.string :pass
      t.float :BTC
      t.float :LTC
      t.float :PPC
      t.float :NMC
      t.float :XPM
      t.integer :AsicMiner
      t.integer :AsicMiner_small
      t.integer :Advanced_Mining_Corp
      t.float :misc1
      t.float :misc2
      t.float :misc3
      t.text :comment
      t.datetime :time_changed

      t.timestamps
    end
  end
end
