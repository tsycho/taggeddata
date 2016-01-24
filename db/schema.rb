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

ActiveRecord::Schema.define(version: 20160123050457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string  "key",     null: false
  end

  add_index "api_keys", ["key"], name: "index_api_keys_on_key", unique: true, using: :btree

  create_table "data", force: :cascade do |t|
    t.integer "user_id",                   null: false
    t.decimal "value"
    t.jsonb   "data"
    t.boolean "is_public", default: false, null: false
    t.text    "tags",      default: [],                 array: true
    t.date    "date",                      null: false
  end

  add_index "data", ["user_id"], name: "index_data_on_user", using: :btree
  add_index "data", ["tags"], name: "index_data_on_tags", using: :gin

  create_table "users", force: :cascade do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "name"
    t.string   "email"
    t.string   "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree

  add_foreign_key "api_keys", "users", on_delete: :cascade
  add_foreign_key "data", "users", on_delete: :cascade
end
