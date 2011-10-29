require 'rubygems'
require 'active_record'

 ActiveRecord::Base.establish_connection(
   :adapter => 'mysql',
   :host => 'localhost',
   :username => 'ririt',
   :password => '********',
   :database => 'RiriT'
 )

class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :tweets, :through => :taggings
#  has_many :rakuten_items, :through => :tweets 
end

class Tagging < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :tag
#  belongs_to :rakuten_item, :through => :tweet 
end

class ItemStream < ActiveRecord::Base
  belongs_to :rakuten_item
end

class RakutenItem < ActiveRecord::Base
  has_many :tweets, :order => 'tweet_id desc'
#  has_many :tags, :through => :taggings
  has_one :item_stream
  named_scope :daily, lambda{|date| 
    {:select => "rakuten_items.*, count(distinct(tweets.twitter_user_id)) as c", :joins => "inner join tweets on tweets.rakuten_item_id = rakuten_items.id", :group => "rakuten_items.id", :order => "c desc", :conditions => ['tweet_date = ?', date]}}
  named_scope :spam_filter, lambda{|spam_point, spammer_point|
    {:conditions => ['rakuten_items.spam_point < ? AND twitter_users.spammer_point < ?', spam_point, spammer_point],
     :joins => 'inner join twitter_users on twitter_users.id = tweets.twitter_user_id'}
  }
  named_scope :item_stream, lambda{|count|
        {:select => "rakuten_items.*, count(distinct(tweets.twitter_user_id)) as c, max(tweets.tweet_id) as max_id", :joins => "inner join tweets on tweets.rakuten_item_id = rakuten_items.id", :group => "rakuten_items.id", :order => "max_id desc", :having => ['c >= ?', count]}}
end

class Tweet < ActiveRecord::Base
  belongs_to :rakuten_item
  belongs_to :twitter_user
  has_many :taggings
  has_many :tags, :through => :taggings
end

class TwitterUser < ActiveRecord::Base
  has_many :tweets
end

#item = RakutenItem.new
#item.shop_name = 'test'
#item.item_name = 'test'
#item.save
#p RakutenItem.find(1)
