class RakutenItem < ActiveRecord::Base
  has_many :rankings
  has_many :tweets, :order => 'tweet_id desc', :limit => 100
  has_one :item_stream
  named_scope :ranking, lambda{|date| {:select => "rakuten_items.*, count(distinct(tweets.twitter_user_id)) as c", :joins => "inner join tweets on tweets.rakuten_item_id = rakuten_items.id", :group => "rakuten_items.id", :order => "c desc", :conditions => ['tweet_date = ?', date]}}
 
  named_scope :item_stream, lambda{|count| 
    {:select => "rakuten_items.*, count(distinct(tweets.twitter_user_id)) as c, max(tweets.tweet_id) as max_id", :joins => "inner join tweets on tweets.rakuten_item_id = rakuten_items.id", :group => "rakuten_items.id", :order => "max_id desc", :having => ['c >= ?', count]}}
  named_scope :spam_filter, lambda{|spam_point, spammer_point|
    {:conditions => ['rakuten_items.spam_point < ? AND twitter_users.spammer_point < ?', spam_point, spammer_point],
     :joins => 'inner join twitter_users on twitter_users.id = tweets.twitter_user_id'}
  }

  #named_scope :limit, lambda{|page, limit|
  #  {:limit => limit, :offset => (page * limit)}
  #}
end
