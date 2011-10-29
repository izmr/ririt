class RakutenItemController < ApplicationController
  def index
    @id = params[:id]
    @head = params[:item_code_head]
    @foot = params[:item_code_foot]
    @item_code = @head + ':' + @foot unless @head.nil? || @foot.nil?
    @rakuten_item = RakutenItem.find_by_id(@id) unless @id.nil?

    if(@id && @rakuten_item)
      @id = ''
      item_code_array = @rakuten_item.item_code.split(':')
      redirect_to url_for(:controller => 'rakuten_item', :action => 'index', :item_code_head => item_code_array[0], :item_code_foot => item_code_array[1]), :status => 301
    end
    @rakuten_item = RakutenItem.find_by_item_code(@item_code) unless @item_code.nil?
  end
end
