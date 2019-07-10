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

ActiveRecord::Schema.define(version: 2019_07_08_112555) do

  create_table "driver_licenses", force: :cascade do |t|
    t.string "category"
    t.date "expiration_date"
    t.integer "driver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["driver_id"], name: "index_driver_licenses_on_driver_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "rides", force: :cascade do |t|
    t.string "status"
    t.boolean "comeback_load"
    t.integer "driver_id"
    t.string "origin"
    t.float "origin_lat"
    t.string "origin_lng"
    t.string "destination"
    t.float "destination_lat"
    t.float "destination_lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_rides_on_driver_id"
  end

  create_table "trucks", force: :cascade do |t|
    t.string "category"
    t.string "model"
    t.string "brand"
    t.boolean "is_loaded"
    t.boolean "driver_owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "driver_id"
    t.index ["driver_id"], name: "index_trucks_on_driver_id"
  end

end
