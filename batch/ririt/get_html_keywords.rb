$KCODE = 'u'
require '../lib/keywords_extractor.rb'
require '../model/tables.rb'

id = 10058
item_name = RakutenItem.find(id).item_name
caption = RakutenItem.find(id).item_caption
q = item_name +':' + item_name + ':' +caption
#q = item_name
puts "query:#{q}"
xml = KeywordExtractor::get(q)
xml.each do |keyword, score|
  p "keyword:#{keyword}, score:#{score}" if score > 40
end
