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

ActiveRecord::Schema.define(version: 20131219085750) do

  create_table "activities", force: true do |t|
    t.string "name"
    t.string "status"
    t.string "create_user"
  end

  create_table "bid_results", force: true do |t|
    t.string "activity"
    t.string "bid_name"
    t.string "name"
    t.string "phone"
    t.float  "price"
    t.string "user"
  end

# Could not dump table "bid_ups" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "bids", force: true do |t|
    t.string "name"
    t.string "activity"
    t.string "status"
    t.string "user"
  end

  create_table "sign_ups", force: true do |t|
    t.string "name"
    t.string "phone"
    t.string "activity"
    t.string "user"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "password_question"
    t.string   "password_question_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                    default: false
    t.integer  "num"
    t.string   "remember_token"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
