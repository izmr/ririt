class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :twitter_user_id
      t.integer :rakuten_item_id
      t.integer :tweet_id
      t.string :text
      t.datetime :tweet_datetime

      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
