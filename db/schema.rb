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

ActiveRecord::Schema.define(:version => 20130604105340) do

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

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "categories", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "category_products", :force => true do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  create_table "order_products", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "quantity"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.text     "address"
    t.string   "status",             :default => "pending"
    t.datetime "status_change_date"
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "product_users", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "in_cart",    :default => false
  end

  create_table "products", :force => true do |t|
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.string   "title"
    t.text     "description"
    t.decimal  "base_price",  :precision => 8, :scale => 2
    t.string   "photo"
    t.boolean  "on_sale",                                   :default => false
    t.integer  "discount"
    t.integer  "order_id"
    t.integer  "quantity",                                  :default => 1
  end

  create_table "reviews", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.text     "body"
    t.integer  "note"
    t.integer  "user_id"
    t.integer  "product_id"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "nick"
    t.string   "email"
    t.boolean  "admin",      :default => false
    t.boolean  "guest",      :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password"
    t.string   "address"
  end

end
