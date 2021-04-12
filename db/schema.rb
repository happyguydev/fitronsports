# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_14_130115) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "facility_types", ["school", "Fitnessstudio", "Schule", "Sportplatz", "Spielplatz", "Andere"]
  create_enum "report_part_rates", ["good", "problematic", "bad"]
  create_enum "report_statuses", ["sent", "draft", "accept", "archived"]
  create_enum "request_statuses", ["pending", "accepted", "rejected", "draft", "sent", "archived"]
  create_enum "request_types", ["service_request", "order_request"]

  create_table "accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "type", null: false
    t.string "name_prefix"
    t.string "first_name"
    t.string "last_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organisation_id"
    t.string "phone_number"
    t.bigint "facility_id"
    t.boolean "terms_of_service", default: false, null: false
    t.boolean "active", default: true
    t.index ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["facility_id"], name: "index_accounts_on_facility_id"
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_accounts_on_unlock_token", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "attachments", force: :cascade do |t|
    t.jsonb "image"
    t.integer "position"
    t.string "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "attachable_type", null: false
    t.bigint "attachable_id", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.enum "facility_type", as: "facility_types"
    t.string "name"
    t.string "street_line1"
    t.string "street_line2"
    t.string "city"
    t.string "postal_code"
    t.decimal "lon", precision: 10, scale: 6
    t.decimal "lat", precision: 10, scale: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
    t.boolean "searchable", default: true
    t.string "contact_name"
    t.string "contact_email"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.string "sku"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
  end

  create_table "report_parts", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.string "title"
    t.string "description"
    t.enum "rate", default: "good", null: false, as: "report_part_rates"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id", null: false
    t.index ["product_id"], name: "index_report_parts_on_product_id"
    t.index ["report_id"], name: "index_report_parts_on_report_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "inspector_account_id", null: false
    t.bigint "facility_id", null: false
    t.string "title"
    t.enum "status", default: "draft", null: false, as: "report_statuses"
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uid"
    t.datetime "deleted"
    t.boolean "failed_to_send", default: false
    t.index ["facility_id"], name: "index_reports_on_facility_id"
    t.index ["inspector_account_id"], name: "index_reports_on_inspector_account_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "janitor_account_id", null: false
    t.bigint "facility_id", null: false
    t.enum "request_type", null: false, as: "request_types"
    t.string "title"
    t.string "description"
    t.string "additional_notes", default: [], array: true
    t.enum "status", default: "pending", null: false, as: "request_statuses"
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.integer "product_quantity", default: 0
    t.string "uid"
    t.datetime "deleted"
    t.index ["facility_id"], name: "index_requests_on_facility_id"
    t.index ["product_id"], name: "index_requests_on_product_id"
  end

  add_foreign_key "accounts", "facilities"
  add_foreign_key "accounts", "organisations"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "report_parts", "products"
  add_foreign_key "report_parts", "reports"
  add_foreign_key "reports", "facilities"
  add_foreign_key "requests", "facilities"
  add_foreign_key "requests", "products"
end
