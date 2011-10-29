class AddTweetDateIndexOnTweets < ActiveRecord::Migration
  def self.up
    add_index(:tweets, :tweet_date)
  end

  def self.down
    remove_index(:tweets, :tweet_date)
  end
end
