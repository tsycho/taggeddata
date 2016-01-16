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
  # Data
  create_table "data", force: :cascade do |t|
    t.decimal  "value",      null: false
    t.text     "tags",       array: true, default: []
    t.date     "date",       null: false
  end

  add_index "data", ["tags"], :using => 'gin', :name => "index_data_on_tags"
end
