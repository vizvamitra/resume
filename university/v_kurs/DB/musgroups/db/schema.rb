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

ActiveRecord::Schema.define(version: 20140219200847) do

  create_table "concerts", force: true do |t|
    t.string   "country"
    t.string   "city"
    t.datetime "date"
    t.integer  "tour_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "title",          null: false
    t.integer  "formation_year"
    t.string   "country"
    t.integer  "top_position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["top_position"], name: "index_groups_on_top_position", unique: true

  create_table "members", force: true do |t|
    t.string   "name"
    t.string   "role"
    t.datetime "birth_date"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", force: true do |t|
    t.string   "title"
    t.string   "music_by"
    t.string   "lyrics_by"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tours", force: true do |t|
    t.string   "title"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
