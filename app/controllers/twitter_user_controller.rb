class TwitterUserController < ApplicationController
  def index
    username = params[:username]
    @twitter_user = TwitterUser.find_by_username(username)
  end

end
