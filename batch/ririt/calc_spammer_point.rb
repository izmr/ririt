$KCODE = 'UTF-8'

require 'rubygems'
require 'active_support/all'
require '../model/tables.rb'
require 'date'

TwitterUser.all.each do |user|
  user.spammer_point = user.tweets.find(:all, :conditions => ['tweet_date >= ?', 1.week.ago]).count
  user.save
end
