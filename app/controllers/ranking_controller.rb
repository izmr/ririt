class RankingController < ApplicationController
  def index
    if(!params[:date].nil? &&
        params[:date].match(/[\w]{4}-[\w]{2}-[\w]{2}/))
      s_date = params[:date].split('-')
      if(Date.valid_date?(s_date[0].to_i, s_date[1].to_i, s_date[2].to_i))
        @date = Date.parse(params[:date])
      end
    end
    if(!params[:limit].nil? &&
        params[:limit].match(/[\w]+/))
      @limit = params[:limit]
    else
      @limit = 10.to_s
    end
    @limit = 100.to_s if @limit.to_i > 100

    if(!params[:page].nil? &&
        params[:page].match(/[\w]+/))
      @page = params[:page]
    else
      @page = 0.to_s
    end
  

    @date = Date.today if @date.nil?

    @ranking = RakutenItem.ranking(@date).spam_filter(35, 10).limit(@limit).offset((@page.to_i * @limit.to_i))
    respond_to do |format|
      format.html
      format.xml    {render :xml => @ranking, :include => :tweets}
      format.json     {render :json => @ranking, :include => :tweets}
    end
  end

end
