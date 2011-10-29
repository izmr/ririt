class AddMaxTweetId < ActiveRecord::Migration
  def self.up
    add_column :item_streams, :max_tweet_id, :bigint, :limit => 20
  end

  def self.down
    remove_column :item_streams, :max_tweet_id
  end
end
