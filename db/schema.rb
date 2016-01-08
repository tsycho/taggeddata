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

ActiveRecord::Schema.define(version: 20160108145237) do
  # Tags
  create_table "tags", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  # Data
  create_table "data", force: :cascade do |t|
    t.decimal  "value",      null: false
    t.integer  "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "data", ["tags"], name: "index_data_on_tags"

  # Join table
  create_table "data_tags", id: false, force: :cascade do |t|
    t.integer "datum_id", null: false
    t.integer "tag_id",   null: false
  end

  add_index "data_tags", ["datum_id", "tag_id"], name: "index_data_tags_on_datum_id_and_tag_id"
  add_index "data_tags", ["tag_id", "datum_id"], name: "index_data_tags_on_tag_id_and_datum_id"

end
