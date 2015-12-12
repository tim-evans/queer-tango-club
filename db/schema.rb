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

ActiveRecord::Schema.define(version: 20151212022206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendee", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "event_id"
    t.string   "payment_method"
    t.string   "payment_url"
    t.datetime "paid_at"
    t.boolean  "attended"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "attendee", ["event_id"], name: "index_attendee_on_event_id", using: :btree
  add_index "attendee", ["member_id"], name: "index_attendee_on_member_id", using: :btree

  create_table "event", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "taught_by"
    t.string   "title"
    t.string   "type"
    t.text     "description"
    t.string   "image_url"
    t.integer  "package_id"
    t.string   "sku"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "event", ["package_id"], name: "index_event_on_package_id", using: :btree
  add_index "event", ["sku"], name: "index_event_on_sku", using: :btree
  add_index "event", ["type"], name: "index_event_on_type", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree

  create_table "package", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.date     "starts_at"
    t.date     "ends_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
