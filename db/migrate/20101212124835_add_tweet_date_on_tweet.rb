class AddTweetDateOnTweet < ActiveRecord::Migration
  def self.up
    add_column(:tweets, :tweet_date, :date)
  end

  def self.down
    remove_column(:tweets, :tweet_date)
  end
end
