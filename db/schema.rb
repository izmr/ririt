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

ActiveRecord::Schema.define(:version => 20110116112427) do

  create_table "genres", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_streams", :force => true do |t|
    t.integer  "rakuten_item_id"
    t.integer  "point"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_tweet_id",    :limit => 8
  end

  add_index "item_streams", ["max_tweet_id"], :name => "index_item_streams_on_max_tweet_id"
  add_index "item_streams", ["point"], :name => "index_item_streams_on_point"
  add_index "item_streams", ["rakuten_item_id"], :name => "index_item_streams_on_rakuten_item_id"
  add_index "item_streams", ["updated_at"], :name => "index_item_streams_on_updated_at"

  create_table "rakuten_items", :force => true do |t|
    t.string   "shop_name"
    t.string   "item_name"
    t.string   "item_code"
    t.string   "title"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_caption",   :limit => 1024
    t.string   "item_url"
    t.string   "affiliate_url"
    t.string   "big_image_url"
    t.integer  "genre_id"
    t.string   "shop_code"
    t.string   "shop_item_code"
    t.integer  "item_price",     :limit => 8
    t.integer  "spam_point"
  end

  add_index "rakuten_items", ["item_code"], :name => "index_rakuten_items_on_item_code", :unique => true
  add_index "rakuten_items", ["shop_item_code"], :name => "index_rakuten_items_on_shop_item_code", :unique => true

  create_table "rankings", :force => true do |t|
    t.date     "ranking_date"
    t.integer  "rakuten_item_id"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tweet_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["tweet_id"], :name => "index_taggings_on_rakuten_item_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["count"], :name => "index_tags_on_count"
  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "tweets", :force => true do |t|
    t.integer  "twitter_user_id"
    t.integer  "rakuten_item_id"
    t.integer  "tweet_id",        :limit => 8
    t.string   "text"
    t.datetime "tweet_datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "tweet_date"
    t.integer  "spam_point"
  end

  add_index "tweets", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets", ["rakuten_item_id"], :name => "index_tweets_on_rakuten_item_id"
  add_index "tweets", ["tweet_date"], :name => "index_tweets_on_tweet_date"
  add_index "tweets", ["tweet_id"], :name => "index_tweets_on_tweet_id", :unique => true
  add_index "tweets", ["twitter_user_id"], :name => "index_tweets_on_twitter_user_id"

  create_table "twitter_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "profile_image_url"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "spammer_point",     :default => 0
  end

  add_index "twitter_users", ["user_id"], :name => "index_twitter_users_on_user_id", :unique => true
  add_index "twitter_users", ["username"], :name => "index_twitter_users_on_username", :unique => true

end
