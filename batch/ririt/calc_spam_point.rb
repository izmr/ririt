$KCODE = 'UTF-8'

require '../model/tables.rb'
require 'date'

daily_item_list = RakutenItem.daily(Date.today)
daily_item_list.each do |item|
  uu = item.tweets.count('distinct(twitter_user_id)')

  spam_point = (1 - (uu.to_f / item.tweets.count)) * 100
  item.spam_point = spam_point
  #p item.id.to_s + ':' + item.spam_point.to_s
  item.save
end
