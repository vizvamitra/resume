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

ActiveRecord::Schema.define(version: 20140530102151) do

  create_table "bill_positions", force: true do |t|
    t.integer  "type_id"
    t.string   "model"
    t.integer  "count"
    t.string   "sn"
    t.integer  "bill_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "receipt_id"
    t.integer  "sz_id"
    t.integer  "nz_id"
    t.boolean  "sz_or_nz"
  end

  create_table "bills", force: true do |t|
    t.string   "ovks_num"
    t.string   "bill_num"
    t.datetime "bill_date"
    t.integer  "vendor_id"
    t.float    "total_sum"
    t.datetime "payment_date"
    t.string   "skan"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closing_date"
    t.string   "closing_skan"
  end

  add_index "bills", ["ovks_num"], name: "index_bills_on_ovks_num", unique: true, using: :btree

  create_table "departments", force: true do |t|
    t.string   "title"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "fio"
    t.string   "phone"
    t.integer  "department_id"
    t.string   "post"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.string   "info"
    t.boolean  "done"
    t.string   "done_info"
    t.integer  "type_id"
    t.integer  "sz_id"
    t.integer  "nz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bill_id"
  end

  create_table "nzs", force: true do |t|
    t.string   "ovks_num"
    t.datetime "date"
    t.string   "contract_num"
    t.string   "code"
    t.string   "destination"
    t.string   "apk_name"
    t.string   "decimal_num"
    t.string   "zav_num"
    t.datetime "buy_till"
    t.integer  "manager_id"
    t.string   "sp_si"
    t.string   "scan"
    t.integer  "given_to_id"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nzs", ["ovks_num"], name: "index_nzs_on_ovks_num", unique: true, using: :btree

  create_table "receipts", force: true do |t|
    t.string   "ovks_num"
    t.string   "scan"
    t.datetime "date"
    t.integer  "employee_id"
    t.integer  "user_id"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "receipts", ["ovks_num"], name: "index_receipts_on_ovks_num", unique: true, using: :btree

  create_table "receipts_szs", id: false, force: true do |t|
    t.integer "receipt_id"
    t.integer "sz_id"
  end

  create_table "sz_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "szs", force: true do |t|
    t.string   "ovks_num"
    t.datetime "date"
    t.string   "sz_type_id"
    t.integer  "employee_id"
    t.boolean  "done"
    t.string   "scan"
    t.integer  "user_id"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "szs", ["ovks_num"], name: "index_szs_on_ovks_num", unique: true, using: :btree

  create_table "types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "password_digest"
    t.string   "fio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendors", force: true do |t|
    t.string   "title"
    t.string   "address"
    t.string   "phone"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
