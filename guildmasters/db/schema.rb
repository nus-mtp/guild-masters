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

ActiveRecord::Schema.define(version: 20151103021106) do

  create_table "adventurer_templates", force: :cascade do |t|
    t.integer  "max_hp"
    t.integer  "max_energy"
    t.integer  "attack"
    t.integer  "defense"
    t.integer  "vision"
    t.integer  "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "adventurer_templates", ["region_id"], name: "index_adventurer_templates_on_region_id"

  create_table "adventurers", force: :cascade do |t|
    t.integer  "hp"
    t.integer  "max_hp"
    t.integer  "energy"
    t.integer  "max_energy"
    t.integer  "attack"
    t.integer  "defense"
    t.integer  "vision"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "guild_id"
    t.integer  "quest_id"
  end

  add_index "adventurers", ["guild_id"], name: "index_adventurers_on_guild_id"
  add_index "adventurers", ["quest_id"], name: "index_adventurers_on_quest_id"

  create_table "events", force: :cascade do |t|
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "gold_spend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "type"
  end

  create_table "facilities", force: :cascade do |t|
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "guildmasters", force: :cascade do |t|
    t.integer  "gold"
    t.integer  "game_time"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guilds", force: :cascade do |t|
    t.integer  "level"
    t.integer  "popularity"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "guildmaster_id"
  end

  add_index "guilds", ["guildmaster_id"], name: "index_guilds_on_guildmaster_id"

  create_table "quests", force: :cascade do |t|
    t.integer  "difficulty"
    t.string   "state"
    t.integer  "reward"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "guild_id"
  end

  add_index "quests", ["guild_id"], name: "index_quests_on_guild_id"

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scouts", force: :cascade do |t|
    t.string   "scout_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end