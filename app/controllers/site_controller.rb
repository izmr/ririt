class SiteController < ApplicationController
  caches_page :sitemap
  def sitemap
    @item_stream = ItemStream.find(:all,:select => 'item_code, rakuten_item_id, rakuten_items.updated_at',:joins => 'inner join rakuten_items on rakuten_items.id = item_streams.rakuten_item_id' , :limit => 10000, :order => 'max_tweet_id desc')
    @twitter_users = TwitterUser.find(:all, :select => 'twitter_users.username, twitter_users.updated_at, max(tweets.tweet_id) as max_tweet_id', :joins => 'inner join tweets on tweets.twitter_user_id = twitter_users.id',:group => 'twitter_users.id' , :conditions => ['twitter_users.spammer_point < ?', 20],:limit => 10000, :order => 'max_tweet_id desc')
    headers['Content-Type'] = 'text/xml; charset=utf-8'
    render(:layout => false)
  end
end
