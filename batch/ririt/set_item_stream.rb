$KCODE = 'UTF-8'
$item_stream_limit = 10 if $item_stream_limit.nil?
$item_stream_limit += 10

require '../model/tables.rb'

RakutenItem.item_stream(1).spam_filter(35, 20).limit($item_stream_limit).each do |rakuten_item|
  item_stream = ItemStream.find_by_rakuten_item_id(rakuten_item.id) || ItemStream.new
  item_stream.rakuten_item_id = rakuten_item.id if item_stream.rakuten_item_id.nil?
  item_stream.point = rakuten_item.c
  item_stream.max_tweet_id = rakuten_item.max_id
  item_stream.save
end
