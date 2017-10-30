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

ActiveRecord::Schema.define(version: 20171030210735) do

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

  create_table "app_integrations", force: :cascade do |t|
    t.integer  "application_id"
    t.integer  "integration_type"
    t.json     "settings"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["application_id"], name: "index_app_integrations_on_application_id", using: :btree
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
    t.integer  "fb_page_id"
    t.integer  "admin_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["admin_id"], name: "index_applications_on_admin_id", using: :btree
    t.index ["fb_application_id"], name: "index_applications_on_fb_application_id", using: :btree
    t.index ["fb_page_id"], name: "index_applications_on_fb_page_id", using: :btree
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

  create_table "fb_lead_destinations", force: :cascade do |t|
    t.integer  "destination_type"
    t.integer  "status",           default: 0
    t.json     "settings"
    t.integer  "admin_id"
    t.integer  "fb_leadform_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["admin_id"], name: "index_fb_lead_destinations_on_admin_id", using: :btree
    t.index ["fb_leadform_id"], name: "index_fb_lead_destinations_on_fb_leadform_id", using: :btree
  end

  create_table "fb_leadforms", force: :cascade do |t|
    t.string   "fb_page_identifier"
    t.string   "fb_form_id"
    t.integer  "admin_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "fb_form_name"
    t.index ["admin_id"], name: "index_fb_leadforms_on_admin_id", using: :btree
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

  create_table "module_capture_the_flag_entries", force: :cascade do |t|
    t.integer  "elapsed_seconds"
    t.integer  "application_id"
    t.integer  "fb_user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["application_id"], name: "index_module_capture_the_flag_entries_on_application_id", using: :btree
    t.index ["fb_user_id"], name: "index_module_capture_the_flag_entries_on_fb_user_id", using: :btree
  end

  create_table "module_catalog_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft",                           null: false
    t.integer  "rgt",                           null: false
    t.integer  "depth",             default: 0, null: false
    t.integer  "children_count",    default: 0, null: false
    t.integer  "featured_image_id"
    t.string   "slug"
    t.integer  "application_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["application_id"], name: "index_module_catalog_categories_on_application_id", using: :btree
    t.index ["lft"], name: "index_module_catalog_categories_on_lft", using: :btree
    t.index ["parent_id"], name: "index_module_catalog_categories_on_parent_id", using: :btree
    t.index ["rgt"], name: "index_module_catalog_categories_on_rgt", using: :btree
  end

  create_table "module_catalog_media", force: :cascade do |t|
    t.string   "attachment_url"
    t.string   "attachment_type"
    t.string   "attachment_alt"
    t.integer  "application_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["application_id"], name: "index_module_catalog_media_on_application_id", using: :btree
  end

  create_table "module_catalog_messages", force: :cascade do |t|
    t.string   "email",          null: false
    t.string   "name"
    t.string   "phone"
    t.text     "content",        null: false
    t.integer  "product_id",     null: false
    t.integer  "fb_user_id"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_module_catalog_messages_on_application_id", using: :btree
    t.index ["fb_user_id"], name: "index_module_catalog_messages_on_fb_user_id", using: :btree
  end

  create_table "module_catalog_products", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "status",            default: 0
    t.boolean  "featured",          default: false
    t.text     "description"
    t.string   "short_description"
    t.string   "price"
    t.string   "regular_price"
    t.string   "sale_price"
    t.datetime "on_sale_from"
    t.datetime "on_sale_to"
    t.integer  "menu_order"
    t.text     "category_ids",      default: [],                 array: true
    t.integer  "featured_image_id"
    t.text     "gallery_media_ids", default: [],                 array: true
    t.integer  "messages_count",    default: 0,     null: false
    t.integer  "application_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["application_id"], name: "index_module_catalog_products_on_application_id", using: :btree
  end

  create_table "module_coupons_vouchers", force: :cascade do |t|
    t.string   "code",           null: false
    t.integer  "application_id"
    t.integer  "fb_user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_module_coupons_vouchers_on_application_id", using: :btree
    t.index ["fb_user_id"], name: "index_module_coupons_vouchers_on_fb_user_id", using: :btree
  end

  create_table "module_form_entries", force: :cascade do |t|
    t.json     "payload"
    t.integer  "application_id"
    t.integer  "fb_user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_module_form_entries_on_application_id", using: :btree
    t.index ["fb_user_id"], name: "index_module_form_entries_on_fb_user_id", using: :btree
  end

  create_table "module_form_schemas", force: :cascade do |t|
    t.json     "structure"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_module_form_schemas_on_application_id", using: :btree
  end

  create_table "module_memory_match_cards", force: :cascade do |t|
    t.string   "attachment_url"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_module_memory_match_cards_on_application_id", using: :btree
  end

  create_table "module_memory_match_entries", force: :cascade do |t|
    t.integer  "time",           default: 0
    t.integer  "clicks",         default: 0
    t.integer  "fb_user_id"
    t.integer  "application_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["application_id"], name: "index_module_memory_match_entries_on_application_id", using: :btree
    t.index ["fb_user_id"], name: "index_module_memory_match_entries_on_fb_user_id", using: :btree
  end

  create_table "module_photo_contest_photos", force: :cascade do |t|
    t.integer  "application_id",                         null: false
    t.integer  "fb_user_id",                             null: false
    t.text     "caption"
    t.integer  "votes_count",                default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "attachment_url", limit: 255
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

  create_table "payola_affiliates", force: :cascade do |t|
    t.string   "code"
    t.string   "email"
    t.integer  "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "percent_off"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true
  end

  create_table "payola_sales", force: :cascade do |t|
    t.string   "email",                limit: 191
    t.string   "guid",                 limit: 191
    t.integer  "product_id"
    t.string   "product_type",         limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.integer  "amount"
    t.integer  "fee_amount"
    t.integer  "coupon_id"
    t.boolean  "opt_in"
    t.integer  "download_count"
    t.integer  "affiliate_id"
    t.text     "customer_address"
    t.text     "business_address"
    t.string   "stripe_customer_id",   limit: 191
    t.string   "currency"
    t.text     "signed_custom_fields"
    t.integer  "owner_id"
    t.string   "owner_type",           limit: 100
    t.index ["coupon_id"], name: "index_payola_sales_on_coupon_id", using: :btree
    t.index ["email"], name: "index_payola_sales_on_email", using: :btree
    t.index ["guid"], name: "index_payola_sales_on_guid", using: :btree
    t.index ["owner_id", "owner_type"], name: "index_payola_sales_on_owner_id_and_owner_type", using: :btree
    t.index ["product_id", "product_type"], name: "index_payola_sales_on_product", using: :btree
    t.index ["stripe_customer_id"], name: "index_payola_sales_on_stripe_customer_id", using: :btree
  end

  create_table "payola_stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_subscriptions", force: :cascade do |t|
    t.string   "plan_type"
    t.integer  "plan_id"
    t.datetime "start"
    t.string   "status"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "stripe_customer_id"
    t.boolean  "cancel_at_period_end"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "ended_at"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "canceled_at"
    t.integer  "quantity"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.string   "state"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.integer  "amount"
    t.string   "guid",                 limit: 191
    t.string   "stripe_status"
    t.integer  "affiliate_id"
    t.string   "coupon"
    t.text     "signed_custom_fields"
    t.text     "customer_address"
    t.text     "business_address"
    t.integer  "setup_fee"
    t.decimal  "tax_percent",                      precision: 4, scale: 2
    t.index ["guid"], name: "index_payola_subscriptions_on_guid", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.json     "conf"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_settings_on_application_id", using: :btree
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.integer  "amount"
    t.string   "interval"
    t.string   "stripe_id"
    t.string   "name"
    t.integer  "trial_period_days"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "two_checkout_notifications", force: :cascade do |t|
    t.json     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "access_tokens", "applications"
  add_foreign_key "access_tokens", "fb_users"
  add_foreign_key "app_integrations", "applications"
  add_foreign_key "application_assets", "applications"
  add_foreign_key "applications", "admins"
  add_foreign_key "applications", "fb_applications"
  add_foreign_key "applications", "fb_pages"
  add_foreign_key "fb_lead_destinations", "admins"
  add_foreign_key "fb_lead_destinations", "fb_leadforms"
  add_foreign_key "fb_leadforms", "admins"
  add_foreign_key "fb_profiles", "admins"
  add_foreign_key "fb_user_api_keys", "fb_users"
  add_foreign_key "module_capture_the_flag_entries", "applications"
  add_foreign_key "module_capture_the_flag_entries", "fb_users"
  add_foreign_key "module_catalog_categories", "applications"
  add_foreign_key "module_catalog_media", "applications"
  add_foreign_key "module_catalog_messages", "applications"
  add_foreign_key "module_catalog_messages", "fb_users"
  add_foreign_key "module_catalog_products", "applications"
  add_foreign_key "module_coupons_vouchers", "applications"
  add_foreign_key "module_coupons_vouchers", "fb_users"
  add_foreign_key "module_form_entries", "applications"
  add_foreign_key "module_form_entries", "fb_users"
  add_foreign_key "module_form_schemas", "applications"
  add_foreign_key "module_memory_match_cards", "applications"
  add_foreign_key "module_memory_match_entries", "applications"
  add_foreign_key "module_memory_match_entries", "fb_users"
  add_foreign_key "settings", "applications"
end
