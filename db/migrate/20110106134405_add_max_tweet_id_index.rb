class AddMaxTweetIdIndex < ActiveRecord::Migration
  def self.up
    add_index :item_streams, :max_tweet_id
  end

  def self.down
    remove_index :item_streams, :column => :max_tweet_id
  end
end
