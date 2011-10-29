$KCODE = 'UTF-8'
require '../model/tables.rb'
require '../model/tables/ranking.rb'

rank = 1
date = Date.today
RakutenItem.daily(date).spam_filter(50, 10).limit(100).each do |item|
  unless(ranking = Ranking.find_by_rank_and_ranking_date(rank, date))
    ranking = Ranking.new
  end
  ranking.rakuten_item_id = item.id
  ranking.ranking_date = date
  ranking.count = item.tweets.count
  ranking.rank = rank
  ranking.save

  rank += 1
end
