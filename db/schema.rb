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

ActiveRecord::Schema.define(version: 20171004165739) do

  create_table "auth_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_auth_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_auth_users_on_reset_password_token", unique: true
  end

  create_table "nats", force: :cascade do |t|
    t.string "name"
    t.integer "ext_port"
    t.integer "int_port"
    t.string "int_ip"
    t.boolean "state"
    t.string "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ext_port"], name: "index_nats_on_ext_port", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.boolean "is_router"
    t.date "date_of_disconnect"
    t.boolean "access_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_users_on_address", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
