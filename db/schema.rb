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

ActiveRecord::Schema.define(:version => 20121221135390) do

  create_table "baseinfos", :primary_key => "uid", :force => true do |t|
    t.string   "screen_name"
    t.string   "location"
    t.string   "description"
    t.string   "url"
    t.string   "domain"
    t.integer  "followers_count"
    t.string   "remark"
    t.boolean  "verified"
    t.string   "email"
    t.string   "qq"
    t.string   "msn"
    t.datetime "updated_at",      :null => false
    t.integer  "fans_count"
    t.integer  "weibo_count"
    t.string   "school"
    t.string   "job"
    t.string   "birthday"
    t.datetime "created_at",      :null => false
    t.string   "certification"
    t.string   "daren"
  end

  create_table "cities", :force => true do |t|
    t.integer  "city_id"
    t.integer  "province_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "cooks", :force => true do |t|
    t.text     "content"
    t.boolean  "expired"
    t.string   "page_type"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "username"
    t.string   "passwd"
    t.boolean  "frequent"
    t.boolean  "forbidden"
    t.string   "owner"
    t.string   "remark"
  end

  create_table "dic_words", :force => true do |t|
    t.string   "word"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "histories", :force => true do |t|
    t.string   "url"
    t.string   "keyword"
    t.integer  "search_count"
    t.integer  "city"
    t.integer  "province"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "role"
    t.boolean  "at_permission"
    t.boolean  "follow_permission"
    t.boolean  "platform_permission"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "export_permission",   :default => false
  end

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "search_keywords", :force => true do |t|
    t.integer  "word_frequency", :limit => 8
    t.integer  "search_count"
    t.string   "keyword"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "result_count"
    t.string   "search_url"
    t.integer  "url_type"
  end

  create_table "tags", :force => true do |t|
    t.integer  "count"
    t.string   "tag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "userinfo_from_searchs", :primary_key => "uid", :force => true do |t|
    t.string   "province"
    t.string   "city"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "user_authorize"
    t.string   "user_age"
    t.string   "user_gender"
    t.boolean  "has_contact",    :default => false
    t.boolean  "has_name",       :default => false
  end

  create_table "users", :primary_key => "uid", :force => true do |t|
    t.integer  "province"
    t.integer  "city"
    t.string   "v"
    t.integer  "age"
    t.string   "gender"
    t.boolean  "has_contact"
    t.boolean  "has_name"
    t.string   "screen_name"
    t.string   "description"
    t.integer  "followers_count"
    t.integer  "fans_count"
    t.integer  "weibo_count"
    t.string   "tags"
    t.string   "email"
    t.string   "qq"
    t.string   "msn"
    t.string   "school"
    t.string   "job"
    t.string   "birthday"
    t.string   "certification"
    t.string   "daren"
    t.boolean  "has_index"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
