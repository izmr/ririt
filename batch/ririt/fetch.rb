$KCODE = 'UTF8'
require 'rubygems'
require 'twitter'
require 'twitter/search'
require '../model/tables.rb'
require '../lib/rakuten_info.rb'
require 'logger'
require 'active_support/time'

Time.zone = 'Asia/Tokyo'

$log = Logger.new('/var/log/ririt/ririt_fetch.log', 'daily')
$item_stream_limit = 0

Signal.trap(:EXIT){
  $log.fatal($!) if $!
}

begin
  $log.info '**************** BATCH START *****************'
  search = Twitter::Search.new
  search.query = {:q => ['item.rakuten.co.jp'], :rpp => 100}
  10.times do |i|
    $log.info '********************** LINE ' + i.to_s + ' **************************'
    found_new_recoreds = false
    line_count = 0
    search.each do |r|
      line_count += 1
      $log.info('^^^^^^^^^^ [' + i.to_s + ':' + line_count.to_s + '] Tweet:' + r.id.to_s + ' ^^^^^^^^^')
      begin
        # tweet_id既に登録済みなら略す
        if(!Tweet.find_by_tweet_id(r.id))
          # twitterユーザを見つけるor登録
          $item_stream_limit += 1
          user = TwitterUser.find_by_user_id r.from_user_id
          if(!user)
            user = TwitterUser.new
            user.user_id = r.from_user_id
            user.profile_image_url = r.profile_image_url
            user.username = r.from_user
            begin
              if(user.save)
                $log.info "****** user saved ******"
                found_new_recoreds = true
              else
                $log.warn "****** cannnot save user *******"
              end
            rescue => e
              $log.error(e.message + ', ' + e.backtrace.join("¥n"))
            end
          else
            $log.info "****** this user already exists ******"
          end
          $log.info('Tweet user:' + user.to_s)

          # 商品情報を見つけるor登録
          RakutenInfo.reset_rakuten_url
          if(shop_item_code = RakutenInfo.get_shop_item_hash(r.text))
            rakuten_item = RakutenItem.find_by_shop_item_code shop_item_code
            if(!rakuten_item)
              $log.info('fetch.rb shop_item_code:' + shop_item_code)
              if(info = RakutenInfo.get_rakuten_info(r.text))
                #@attributes={"Item"=>[#<RakutenItemCodeAPI::Body::ItemCodeSearch::Items::Item
                $log.info('fetch.rb RakutenInfo.get_rakuten_info(r.text):' + info.inspect)
                begin
                  next if info.nil?
                  info = info.attributes['Body']
                  next if info.nil?
                  info = info.attributes['ItemCodeSearch']
                  info = info.attributes['Items']
                  info = info.attributes['Item'].first
                  info = info.attributes
                rescue => e
                  $log.error('fetch.rb Fail!! RakutenItemCodeAPI: ' + info.inspect)
                  $log.error(e.message + ', ' + e.backtrace.join("¥n"))
                  break;
                end
                
                rakuten_item = RakutenItem.find_by_item_code(info['itemCode'])
                if(!rakuten_item)
                  $log.info "***** rakuten_item saving"
                  rakuten_item = RakutenItem.new
                  rakuten_item.shop_item_code = shop_item_code
                  rakuten_item.shop_name = info['shopName']
                  rakuten_item.item_name = info['itemName']
                  rakuten_item.item_caption = info['itemCaption']
                  rakuten_item.item_price = info['itemPrice']
                  rakuten_item.image_url = info['smallImageUrl']
                  rakuten_item.big_image_url = info['mediumImageUrl']
                  rakuten_item.affiliate_url = info['affiliateUrl']
                  rakuten_item.genre_id = info['genreId']
                  rakuten_item.shop_code = info['shopCode']
                  rakuten_item.item_code = info['itemCode']
                  rakuten_item.item_url = info['itemUrl']
                  if(rakuten_item.save)
                    $log.info('***** rakuten_item saved:' + rakuten_item.to_s)
                    found_new_recoreds = true
                  else
                    $log.warn('***** cannot save rakuten_item:' + rakuten_item.to_s)
                  end
                end
              end
            else
              $log.info('***** this rakuten_item already exists')
            end
            $log.info('fetch.rb rakuten_item: ' + rakuten_item.to_s)

            if(rakuten_item)
              find_flg = true

              user = TwitterUser.find_by_user_id r.from_user_id
              # tweetを登録
              tweet = Tweet.new
              tweet.twitter_user_id = user.id
              tweet.rakuten_item_id = rakuten_item.id
              tweet.tweet_id = r.id
              tweet.text = r.text
              tweet.tweet_datetime = Time.zone.parse(r.created_at).localtime
              #tweet.tweet_date = Date.today
              tweet.tweet_date = Time.zone.parse(r.created_at).localtime
              if(tweet.save)
                $log.info "***** tweet saved(#{tweet.id}) ******"
                found_new_recoreds = true
                begin
                  if tags = r.text.scan(/\{([^\{\}]*)\}/)
                    tags.each do |tag_name|
                      tag = Tag.find_by_name tag_name
                      unless tag
                        tag = Tag.new
                        tag.name = tag_name
                        tag.save
                        $log.info "***** tag saved(id:#{tag.id} ,name:#{tag.name}) ******"
                      end
                      tagging = Tagging.new
                      tagging.tweet_id = tweet.id
                      tagging.tag_id = tag.id
                      tagging.save
                      $log.info "****** tagging saved(id:#{tagging.id}, tweet_id:#{tagging.tweet_id}, tag_id:#{tagging.tag_id}) ****** "
                    end
                  end
                rescue => e
                  $log.error(e.message + ', ' + e.backtrace.join("¥n"))
                end
              else
                $log.warn "***** cannot save tweet******"
              end
              $log.info tweet
            else
              $log.warn "***** rakuten_item is nil ******"
            end
          end
        else
          $log.info('This tweet already exists:' + r.id.to_s)
        end
      rescue Mysql::Error => e 
        $log.error(e.message + ', ' + e.backtrace.join("¥n"))
      end
    end
    $log.info '+++++++++ found_new_recoreds:' + found_new_recoreds.to_s
    unless(found_new_recoreds)
      break
    end
    search.fetch_next_page
  end
  $log.info '********************** BATCH FINISHED **************************'
  $log.info '********************** CALC SPAM POINT START **************************'
  require 'calc_spam_point.rb'
  $log.info '********************** CALC SPAM POINT FINISHED **************************'

  $log.info '********************** CALC RANKING START **************************'
  require 'calc_ranking.rb'
  $log.info '********************** CALC RANKING END **************************'

  $log.info '********************** SET ITEM STREAM START **************************'
  $log.info '$item_stream_limit = ' + $item_stream_limit.to_s
  require 'set_item_stream.rb'
  $log.info '********************** SET ITEM STREAM END **************************'

rescue => e
  $log.error(e.message + ', ' + e.backtrace.join("¥n"))
end
