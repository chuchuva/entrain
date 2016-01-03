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

ActiveRecord::Schema.define(version: 20151102203711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invites", force: true do |t|
    t.string   "invite_key",    limit: 32, null: false
    t.string   "email",                    null: false
    t.integer  "invited_by_id",            null: false
    t.integer  "user_id"
    t.datetime "redeemed_at"
    t.datetime "deleted_at"
    t.integer  "deleted_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "invites", ["site_id"], name: "index_invites_on_site_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "site_id"
    t.integer  "program_id"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.decimal  "amount",     precision: 15, scale: 2
    t.string   "pay_method"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "site_id"
    t.integer  "program_id"
    t.string   "slug",       null: false
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["program_id"], name: "index_pages_on_program_id", using: :btree

  create_table "programs", force: true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",      precision: 15, scale: 2
  end

  add_index "programs", ["site_id"], name: "index_programs_on_site_id", using: :btree

  create_table "site_settings", force: true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_settings", ["site_id", "name"], name: "index_site_settings_on_site_id_and_name", using: :btree

  create_table "sites", force: true do |t|
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "texts", force: true do |t|
    t.integer  "site_id"
    t.integer  "program_id"
    t.string   "text_type"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "texts", ["program_id"], name: "index_texts_on_program_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                   limit: 256,                 null: false
    t.string   "password_digest",                                     null: false
    t.string   "auth_token",              limit: 32
    t.inet     "ip_address"
    t.inet     "registration_ip_address"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.boolean  "password_set",                        default: false
    t.integer  "site_id"
    t.boolean  "admin",                               default: false
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "activation_digest"
    t.datetime "password_set_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["site_id"], name: "index_users_on_site_id", using: :btree

end
