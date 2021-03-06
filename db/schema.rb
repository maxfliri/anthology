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

ActiveRecord::Schema.define(:version => 20130207223017) do

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "isbn"
    t.string   "author"
    t.string   "google_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "created_by_id"
    t.string   "openlibrary_id"
  end

  create_table "copies", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "reference"
    t.boolean  "on_loan",       :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "resource_type", :default => "Book"
  end

  create_table "devices", :force => true do |t|
    t.string   "model"
    t.string   "image"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "created_by_id"
    t.boolean  "trashed",       :default => false, :null => false
  end

  create_table "loans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "copy_id"
    t.string   "state",       :default => "on_loan"
    t.datetime "loan_date"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "return_date"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "nickname"
    t.string   "email"
    t.string   "provider"
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
