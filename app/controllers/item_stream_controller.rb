class ItemStreamController < ApplicationController
  def index
    @count = params[:count]
    @count = @count.to_s.match(/\w{1,2}/) ? @count : 3
    @count = 100 if @count.to_i > 100
    @limit = params[:limit]
    @limit = @limit.to_s.match(/\w{1,2}/) ? @limit : 10
    @limit = 50 if @limit.to_i > 50
    @page  = params[:page]
    @page  = @page.to_s.match(/\w{1,2}/) ? @page : 0
    @search_word = params[:search_word]

    if(@search_word.nil? || @search_word == '')
      #@item_stream = RakutenItem.item_stream(@count).spam_filter(50, 10).find(:all, :limit => @limit, :offset => (@page.to_i * @limit.to_i))
      @item_stream = ItemStream.find(:all, :conditions => ['point >= ?', @count], :limit => @limit, :offset => (@page.to_i * @limit.to_i), :order => 'max_tweet_id desc')
    else
      @item_stream = ItemStream.find(:all,:joins => 'inner join rakuten_items on item_streams.rakuten_item_id = rakuten_items.id inner join tweets on tweets.rakuten_item_id = rakuten_items.id inner join twitter_users on tweets.twitter_user_id = twitter_users.id' ,:group => 'item_streams.rakuten_item_id', :conditions => ['point >= ? AND item_name like ? OR item_caption like ? OR tweets.text like ? OR twitter_users.username = ? OR shop_name like ?', @count, "%#{@search_word}%" , "%#{@search_word}%", "%#{@search_word}%", @search_word, "%#{@search_word}%" ], :limit => @limit, :offset => (@page.to_i * @limit.to_i), :order => 'max_tweet_id desc')
      #@item_stream = RakutenItem.item_stream(@count).spam_filter(50, 10).find(:all, :limit => @limit, :offset => (@page.to_i * @limit.to_i), :conditions => ['item_name like ? OR item_caption like ? OR tweets.text like ? OR twitter_users.username = ? OR shop_name like ?', "%#{@search_word}%" , "%#{@search_word}%", "%#{@search_word}%", @search_word, "%#{@search_word}%"])
    end
    respond_to do |format|
        format.html
        format.xml    {render :xml => @item_stream, :include => :rakuten_item}
        format.json     {render :json => @item_stream, :include => :rakuten_item}
    end

  end
end
