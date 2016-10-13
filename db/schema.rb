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

ActiveRecord::Schema.define(version: 20161011041231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "fb_user_id"
    t.integer  "application_id"
    t.string   "checksum"
    t.string   "identifier"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_access_tokens_on_application_id", using: :btree
    t.index ["fb_user_id"], name: "index_access_tokens_on_fb_user_id", using: :btree
  end

  create_table "admins", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["email"], name: "index_admins_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "application_assets", force: :cascade do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "application_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["application_id"], name: "index_application_assets_on_application_id", using: :btree
  end

  create_table "applications", force: :cascade do |t|
    t.string   "title"
    t.string   "checksum"
    t.string   "application_type"
    t.integer  "status",            default: 0
    t.integer  "fb_users_count"
    t.integer  "fb_application_id"
    t.integer  "admin_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["admin_id"], name: "index_applications_on_admin_id", using: :btree
    t.index ["fb_application_id"], name: "index_applications_on_fb_application_id", using: :btree
  end

  create_table "applications_fb_applications", id: false, force: :cascade do |t|
    t.integer "application_id",    null: false
    t.integer "fb_application_id", null: false
  end

  create_table "applications_fb_pages", id: false, force: :cascade do |t|
    t.integer "application_id", null: false
    t.integer "fb_page_id",     null: false
  end

  create_table "fb_applications", force: :cascade do |t|
    t.string   "name"
    t.string   "app_id"
    t.string   "secret_key"
    t.string   "application_type"
    t.string   "canvas_id"
    t.string   "namespace"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "fb_pages", force: :cascade do |t|
    t.string   "name"
    t.integer  "like_count"
    t.string   "identifier"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "webhook_subscribed", default: false
  end

  create_table "fb_pages_profiles", id: false, force: :cascade do |t|
    t.integer "fb_profile_id", null: false
    t.integer "fb_page_id",    null: false
  end

  create_table "fb_profiles", force: :cascade do |t|
    t.string   "identifier"
    t.string   "access_token"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "admin_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["admin_id"], name: "index_fb_profiles_on_admin_id", using: :btree
  end

  create_table "fb_user_api_keys", force: :cascade do |t|
    t.string   "token"
    t.integer  "fb_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fb_user_id"], name: "index_fb_user_api_keys_on_fb_user_id", using: :btree
  end

  create_table "fb_users", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "identifier"
    t.string   "email"
    t.string   "token_for_business"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "module_photo_contest_photos", force: :cascade do |t|
    t.integer  "application_id",                                  null: false
    t.integer  "fb_user_id",                                      null: false
    t.text     "caption"
    t.integer  "votes_count",                         default: 0
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "module_photo_contest_votes", force: :cascade do |t|
    t.integer  "application_id", null: false
    t.integer  "fb_user_id",     null: false
    t.integer  "photo_id",       null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "module_trivia_answers", force: :cascade do |t|
    t.integer  "correct",            limit: 2, default: 0
    t.integer  "option_id",                                null: false
    t.integer  "question_id",                              null: false
    t.integer  "application_id",                           null: false
    t.integer  "fb_user_id",                   default: 0
    t.integer  "fb_user_summary_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "module_trivia_options", force: :cascade do |t|
    t.string   "text",        limit: 255
    t.boolean  "correct",                 default: true
    t.integer  "question_id",                            null: false
    t.integer  "position",                default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "module_trivia_questions", force: :cascade do |t|
    t.string   "text",           limit: 255
    t.integer  "application_id",                            null: false
    t.boolean  "active",                     default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "module_trivia_user_summaries", force: :cascade do |t|
    t.integer  "total_answers",         default: 0
    t.integer  "total_correct_answers", default: 0
    t.float    "qualification",         default: 0.0
    t.integer  "application_id",        default: 0
    t.integer  "fb_user_id",            default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "settings", force: :cascade do |t|
    t.json     "conf"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_settings_on_application_id", using: :btree
  end

  add_foreign_key "access_tokens", "applications"
  add_foreign_key "access_tokens", "fb_users"
  add_foreign_key "application_assets", "applications"
  add_foreign_key "applications", "admins"
  add_foreign_key "applications", "fb_applications"
  add_foreign_key "fb_profiles", "admins"
  add_foreign_key "fb_user_api_keys", "fb_users"
  add_foreign_key "settings", "applications"
end
