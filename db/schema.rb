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

ActiveRecord::Schema.define(version: 2021_01_09_184542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.date "date"
    t.decimal "amount"
    t.text "tags"
    t.string "transaction_type", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "category", limit: 255
    t.text "raw_description"
    t.string "description_id", limit: 255
    t.date "triggered_apply_to_similar"
    t.date "original_date"
    t.string "source", limit: 255
    t.decimal "amount_non_gbp"
    t.string "non_gbp_currency"
    t.decimal "raw_amount"
    t.string "raw_amount_string"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
