# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_08_134601) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.string "organization_name", null: false
    t.string "iban", null: false
    t.string "bic", null: false
    t.integer "balance_cents", default: 0, null: false
    t.string "balance_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iban", "bic"], name: "index_bank_accounts_on_iban_and_bic", unique: true
  end

  create_table "transfers", force: :cascade do |t|
    t.string "counterparty_name", null: false
    t.string "counterparty_iban", null: false
    t.string "counterparty_bic", null: false
    t.string "description", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.bigint "bank_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_transfers_on_bank_account_id"
  end

  add_foreign_key "transfers", "bank_accounts"
end
