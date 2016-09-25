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

ActiveRecord::Schema.define(version: 20160924065726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.integer  "application_id"
    t.string   "checksum"
    t.boolean  "processed"
    t.string   "user_identifier"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "admin_user_api_keys", force: :cascade do |t|
    t.string   "token"
    t.integer  "admin_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["admin_user_id"], name: "index_admin_user_api_keys_on_admin_user_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "identifier",        limit: 20
    t.string   "access_token"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "locale"
    t.string   "utype"
    t.integer  "total_likes_count"
    t.integer  "timezone"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "status",                       default: "pending"
  end

  create_table "admin_users_fb_pages", id: false, force: :cascade do |t|
    t.integer "admin_user_id", null: false
    t.integer "fb_page_id",    null: false
  end

  create_table "application_assets", force: :cascade do |t|
    t.string   "type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "application_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "applications", force: :cascade do |t|
    t.string   "title"
    t.string   "checksum"
    t.string   "application_type"
    t.integer  "status",                  default: 0
    t.integer  "fb_application_id"
    t.integer  "admin_user_id"
    t.integer  "users_count",             default: 0
    t.integer  "fb_page_id"
    t.integer  "timezone"
    t.datetime "first_time_installed_on"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
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
    t.string   "name",       limit: 255
    t.integer  "fan_count"
    t.bigint   "identifier"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "module_trivia_answers", force: :cascade do |t|
    t.integer  "correct",         limit: 2, default: 0
    t.integer  "option_id",                             null: false
    t.integer  "question_id",                           null: false
    t.integer  "application_id",                        null: false
    t.integer  "user_id",                   default: 0
    t.integer  "user_summary_id"
    t.datetime "created_on",                            null: false
    t.datetime "updated_on"
  end

  create_table "module_trivia_options", force: :cascade do |t|
    t.string   "text",        limit: 255
    t.boolean  "correct",                 default: true
    t.integer  "question_id",                            null: false
    t.integer  "position",                default: 0
    t.datetime "created_on",                             null: false
    t.datetime "updated_on"
  end

  create_table "module_trivia_questions", force: :cascade do |t|
    t.string   "text",           limit: 255
    t.integer  "application_id",                            null: false
    t.boolean  "active",                     default: true
    t.datetime "created_on",                                null: false
    t.datetime "updated_on"
  end

  create_table "module_trivia_user_summaries", force: :cascade do |t|
    t.integer  "total_answers",         default: 0
    t.integer  "total_correct_answers", default: 0
    t.float    "qualification",         default: 0.0
    t.integer  "application_id",        default: 0
    t.integer  "user_id",               default: 0
    t.datetime "created_on",                          null: false
    t.datetime "updated_on"
  end

  create_table "settings", force: :cascade do |t|
    t.text     "conf"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_settings_on_application_id", using: :btree
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_api_keys", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_api_keys_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "identifier"
    t.string   "email"
    t.string   "token_for_business"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_foreign_key "admin_user_api_keys", "admin_users"
  add_foreign_key "settings", "applications"
  add_foreign_key "user_api_keys", "users"
end
