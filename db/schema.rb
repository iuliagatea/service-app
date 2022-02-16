# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_180_724_095_623_112_805) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'categories', force: :cascade do |t|
    t.string   'entity'
    t.string   'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'estimates', force: :cascade do |t|
    t.string   'name'
    t.float    'quantity'
    t.float    'price'
    t.float    'value'
    t.integer  'tenant_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer  'product_id'
  end

  add_index 'estimates', ['product_id'], name: 'index_estimates_on_product_id', using: :btree
  add_index 'estimates', ['tenant_id'], name: 'index_estimates_on_tenant_id', using: :btree

  create_table 'members', force: :cascade do |t|
    t.integer  'tenant_id'
    t.integer  'user_id'
    t.string   'first_name'
    t.string   'last_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'members', ['tenant_id'], name: 'index_members_on_tenant_id', using: :btree
  add_index 'members', ['user_id'], name: 'index_members_on_user_id', using: :btree

  create_table 'payments', force: :cascade do |t|
    t.string   'email'
    t.string   'token'
    t.integer  'tenant_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'payments', ['tenant_id'], name: 'index_payments_on_tenant_id', using: :btree

  create_table 'pg_search_documents', force: :cascade do |t|
    t.text     'content'
    t.integer  'searchable_id'
    t.string   'searchable_type'
    t.datetime 'created_at',      null: false
    t.datetime 'updated_at',      null: false
  end

  add_index 'pg_search_documents', %w[searchable_type searchable_id],
            name: 'index_pg_search_documents_on_searchable_type_and_searchable_id', using: :btree

  create_table 'product_statuses', force: :cascade do |t|
    t.integer  'product_id'
    t.integer  'status_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'product_statuses', ['product_id'], name: 'index_product_statuses_on_product_id', using: :btree
  add_index 'product_statuses', ['status_id'], name: 'index_product_statuses_on_status_id', using: :btree

  create_table 'products', force: :cascade do |t|
    t.string   'code'
    t.string   'name'
    t.date     'expected_completion_date'
    t.integer  'tenant_id'
    t.integer  'user_id'
    t.datetime 'created_at',               null: false
    t.datetime 'updated_at',               null: false
    t.text     'comments'
  end

  add_index 'products', ['tenant_id'], name: 'index_products_on_tenant_id', using: :btree
  add_index 'products', ['user_id'], name: 'index_products_on_user_id', using: :btree

  create_table 'reviews', force: :cascade do |t|
    t.integer  'tenant_id'
    t.integer  'user_id'
    t.string   'title'
    t.text     'review'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'reviews', ['tenant_id'], name: 'index_reviews_on_tenant_id', using: :btree
  add_index 'reviews', ['user_id'], name: 'index_reviews_on_user_id', using: :btree

  create_table 'seems_rateable_rates', force: :cascade do |t|
    t.integer  'rater_id'
    t.integer  'rateable_id'
    t.string   'rateable_type'
    t.float    'stars', null: false
    t.text     'comment'
    t.string   'dimension'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'seems_rateable_rates', ['dimension'], name: 'index_seems_rateable_rates_on_dimension', using: :btree
  add_index 'seems_rateable_rates', %w[rateable_id rateable_type],
            name: 'index_seems_rateable_rates_on_rateable_id_and_rateable_type', using: :btree
  add_index 'seems_rateable_rates', ['rater_id'], name: 'index_seems_rateable_rates_on_rater_id', using: :btree

  create_table 'sessions', force: :cascade do |t|
    t.string   'session_id', null: false
    t.text     'data'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'sessions', ['session_id'], name: 'index_sessions_on_session_id', unique: true, using: :btree
  add_index 'sessions', ['updated_at'], name: 'index_sessions_on_updated_at', using: :btree

  create_table 'statuses', force: :cascade do |t|
    t.string   'name'
    t.string   'color'
    t.integer  'tenant_id'
    t.datetime 'created_at',                    null: false
    t.datetime 'updated_at',                    null: false
    t.boolean  'is_active',      default: true
    t.boolean  'can_be_deleted', default: true
    t.boolean  'send_email',     default: true
  end

  add_index 'statuses', ['tenant_id'], name: 'index_statuses_on_tenant_id', using: :btree

  create_table 'tenant_categories', force: :cascade do |t|
    t.integer  'tenant_id'
    t.integer  'category_id'
    t.datetime 'created_at',  null: false
    t.datetime 'updated_at',  null: false
  end

  add_index 'tenant_categories', ['category_id'], name: 'index_tenant_categories_on_category_id', using: :btree
  add_index 'tenant_categories', ['tenant_id'], name: 'index_tenant_categories_on_tenant_id', using: :btree

  create_table 'tenants', force: :cascade do |t|
    t.integer  'tenant_id'
    t.string   'name'
    t.datetime 'created_at',  null: false
    t.datetime 'updated_at',  null: false
    t.string   'plan'
    t.string   'description'
    t.string   'keywords'
  end

  add_index 'tenants', ['name'], name: 'index_tenants_on_name', using: :btree
  add_index 'tenants', ['tenant_id'], name: 'index_tenants_on_tenant_id', using: :btree

  create_table 'tenants_users', id: false, force: :cascade do |t|
    t.integer 'tenant_id', null: false
    t.integer 'user_id',   null: false
  end

  add_index 'tenants_users', %w[tenant_id user_id], name: 'index_tenants_users_on_tenant_id_and_user_id',
                                                    using: :btree

  create_table 'users', force: :cascade do |t|
    t.string   'email',                        default: '',    null: false
    t.string   'encrypted_password',           default: '',    null: false
    t.string   'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet     'current_sign_in_ip'
    t.inet     'last_sign_in_ip'
    t.string   'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string   'unconfirmed_email'
    t.boolean  'skip_confirm_change_password', default: false
    t.integer  'tenant_id'
    t.datetime 'created_at',                                   null: false
    t.datetime 'updated_at',                                   null: false
    t.boolean  'is_admin', default: false
  end

  add_index 'users', ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true, using: :btree
  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree

  add_foreign_key 'estimates', 'products'
  add_foreign_key 'estimates', 'tenants'
  add_foreign_key 'members', 'tenants'
  add_foreign_key 'members', 'users'
  add_foreign_key 'payments', 'tenants'
  add_foreign_key 'product_statuses', 'products'
  add_foreign_key 'product_statuses', 'statuses'
  add_foreign_key 'products', 'tenants'
  add_foreign_key 'products', 'users'
  add_foreign_key 'reviews', 'tenants'
  add_foreign_key 'reviews', 'users'
  add_foreign_key 'statuses', 'tenants'
  add_foreign_key 'tenant_categories', 'categories'
  add_foreign_key 'tenant_categories', 'tenants'
  add_foreign_key 'tenants', 'tenants'
end
