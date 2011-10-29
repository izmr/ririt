class Tweet < ActiveRecord::Base
  belongs_to :rakuten_item
  belongs_to :twitter_user

end
