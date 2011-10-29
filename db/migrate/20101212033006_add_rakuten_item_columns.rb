class AddRakutenItemColumns < ActiveRecord::Migration
  def self.up
    #change_column(:tweets, :tweet_id, :bigint, :limit => 20)
    #add_index(:tweets, :tweet_id, {:unique => true})
    #add_column(:rakuten_items, :item_caption, :string, :limit => 512)
    #add_column(:rakuten_items, :item_url, :string)
    #add_column(:rakuten_items, :affiliate_url, :string)
    #add_column(:rakuten_items, :big_image_url, :string)
    #add_column(:rakuten_items, :genre_id, :integer)
    #add_column(:rakuten_items, :shop_code, :string)
    #add_index(:rakuten_items, :item_code, {:unique => true})
    #remove_index(:rakuten_items, [:shop_name, :item_name])
  end

  def self.down
    #change_column(:tweets, :tweet_id, :integer)
    #remove_index(:tweets, :tweet_id)
    #remove_column(:rakuten_items, :item_caption)
    #remove_column(:rakuten_items, :item_url)
    #remove_column(:rakuten_items, :affiliate_url)
    #remove_column(:rakuten_items, :big_image_url)
    #remove_column(:rakuten_items, :genre_id)
    #remove_column(:rakuten_items, :shop_code)
    #remove_index(:rakuten_items, :item_code)
    #add_index(:rakuten_items, [:shop_name, :item_name], {unique => true})
  end
end
