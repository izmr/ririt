class TwitterUser < ActiveRecord::Base
  has_many :tweets, :order => 'id desc', :limit => 50
end
