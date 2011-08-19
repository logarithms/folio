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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110818193242) do

  create_table "executions", :force => true do |t|
    t.integer  "qty"
    t.integer  "trade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roundtrips", :force => true do |t|
    t.integer  "open_id"
    t.integer  "close_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trades", :force => true do |t|
    t.string   "ameritradeid"
    t.string   "symbol"
    t.date     "date"
    t.integer  "qty"
    t.float    "amount"
    t.integer  "action_cd"
    t.integer  "state_cd"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position_cd"
  end

end
