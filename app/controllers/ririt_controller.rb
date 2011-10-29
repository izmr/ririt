class RiritController < ApplicationController
  def sitemap
    redirect_to url_for(:controller => 'site', :action => 'sitemap')
  end
  def twitter_user
    username = params[:username]
    redirect_to url_for(:controller => 'twitter_user', :action => 'index', :username => username), :status => 301
  end
  def ranking
    @date = params[:date]
    if @date
      redirect_to url_for(:controller => 'ranking', :action => 'index', :date => @date), :status => 301
    else
      redirect_to url_for(:controller => 'ranking', :action => 'index'), :status => 301
    end
  end
  def rakuten_item
    @id = params[:id]
    @head = params[:item_code_head]
    @foot = params[:item_code_foot]
    unless @id || @head || @foot
      redurect_to url_for(:controller => 'item_stream'), :status => 301
    else
      if @id
        redirect_to url_for(:controller => 'rakuten_item', :id => @id), :status => 301
      else
        redirect_to url_for(:controller => 'rakuten_item', :item_code_head => @head, :item_code_foot => @foot), :status => 301
      end
    end
  end
  def item_stream
    @count = params[:count]
    @limit = params[:limit]
    @page  = params[:page]
    unless @count || @limit || @page
      redirect_to url_for(:controller => 'item_stream', :action => 'index'), :status => 301
      return
    end

    @count = @count.to_s.match(/\w{1,2}/) ? @count : 3
    @count = 100 if @count.to_i > 100
    @limit = @limit.to_s.match(/\w{1,2}/) ? @limit : 10
    @limit = 50 if @limit.to_i > 50
    @page  = @page.to_s.match(/\w{1,2}/) ? @page : 0
    @search_word = params[:search_word]

    if @count || @limit || @page
      unless @search_word
        redirect_to "/item_stream/#{@count}/limit/#{@limit}/page/#{@page}", :status => 301
      else
        redirect_to "/item_stream/#{@count}/limit/#{@limit}/page/#{@page}/q/#{@search_word}", :status => 301
      end
    end
  end
end
