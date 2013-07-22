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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130720210740) do

  create_table "addresses", :force => true do |t|
    t.string  "country"
    t.string  "city"
    t.integer "zip_code"
    t.string  "street"
    t.integer "house_nr"
    t.integer "door_nr"
    t.integer "user_id"
    t.integer "order_id"
  end

  add_index "addresses", ["order_id"], :name => "addresses_order_id_ix"
  add_index "addresses", ["user_id"], :name => "addresses_user_id_ix"

  create_table "assets", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "description"
  end

  add_index "assets", ["product_id"], :name => "assets_product_id_ix"

  create_table "categories", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "categories_sales", :force => true do |t|
    t.integer "category_id"
    t.integer "sale_id"
  end

  add_index "categories_sales", ["category_id"], :name => "cat_sal_category_id_ix"
  add_index "categories_sales", ["sale_id"], :name => "cat_sal_product_id_ix"

  create_table "category_products", :force => true do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  create_table "order_products", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "quantity"
    t.integer  "discount",            :default => 100
    t.integer  "base_price_cents",    :default => 0,     :null => false
    t.string   "base_price_currency", :default => "USD", :null => false
  end

  add_index "order_products", ["order_id"], :name => "ord_pro_order_id_ix"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "status",             :default => "pending"
    t.datetime "status_change_date"
    t.integer  "price_cents",        :default => 0,         :null => false
    t.string   "price_currency",     :default => "USD",     :null => false
    t.integer  "discount",           :default => 100
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "product_users", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "in_cart",    :default => false
    t.integer  "quantity",   :default => 0
  end

  add_index "product_users", ["product_id"], :name => "pro_use_product_id_ix"
  add_index "product_users", ["user_id"], :name => "pro_use_user_id_ix"

  create_table "products", :force => true do |t|
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "title"
    t.text     "description"
    t.string   "photo"
    t.boolean  "on_sale",             :default => false
    t.integer  "discount",            :default => 100
    t.integer  "order_id"
    t.integer  "quantity",            :default => 1
    t.integer  "base_price_cents",    :default => 0,     :null => false
    t.string   "base_price_currency", :default => "USD", :null => false
  end

  add_index "products", ["order_id"], :name => "products_order_id_ix"

  create_table "products_sales", :force => true do |t|
    t.integer "product_id"
    t.integer "sale_id"
  end

  add_index "products_sales", ["product_id"], :name => "pro_sal_product_id_ix"
  add_index "products_sales", ["sale_id"], :name => "pro_sal_sale_id_ix"

  create_table "reviews", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.text     "body"
    t.integer  "note"
    t.integer  "user_id"
    t.integer  "product_id"
  end

  add_index "reviews", ["product_id"], :name => "reviews_product_id_ix"
  add_index "reviews", ["user_id"], :name => "reviews_user_id_ix"

  create_table "sales", :force => true do |t|
    t.integer  "discount"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "nick"
    t.string   "email"
    t.boolean  "admin",           :default => false
    t.boolean  "guest",           :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.boolean  "activated",       :default => false
  end

end
