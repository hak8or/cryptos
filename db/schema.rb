# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130714090217) do

  create_table "fiveminute_timed_assets", force: true do |t|
    t.float    "BTC"
    t.float    "LTC"
    t.float    "PPC"
    t.float    "NMC"
    t.float    "XPM"
    t.float    "AsicMiner"
    t.float    "AsicMiner_small"
    t.float    "Advanced_Mining_Corp"
    t.float    "misc1"
    t.float    "misc2"
    t.float    "misc3"
    t.text     "comment"
    t.datetime "time_changed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timed_assets", force: true do |t|
    t.float    "BTC"
    t.float    "LTC"
    t.float    "PPC"
    t.float    "NMC"
    t.float    "XPM"
    t.float    "AsicMiner"
    t.float    "AsicMiner_small"
    t.float    "Advanced_Mining_Corp"
    t.float    "misc1"
    t.float    "misc2"
    t.float    "misc3"
    t.text     "comment"
    t.datetime "time_changed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_infos", force: true do |t|
    t.string   "user"
    t.string   "pass"
    t.float    "BTC"
    t.float    "LTC"
    t.float    "PPC"
    t.float    "NMC"
    t.float    "XPM"
    t.integer  "AsicMiner"
    t.integer  "AsicMiner_small"
    t.integer  "Advanced_Mining_Corp"
    t.float    "misc1"
    t.float    "misc2"
    t.float    "misc3"
    t.text     "comment"
    t.datetime "time_changed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
