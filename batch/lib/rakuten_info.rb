require 'uri'
require 'net/http'
require '../model/rakuten_item_code_api.rb'

class RakutenInfo
  @@rakuten_url = nil
  def  self.reset_rakuten_url
    @@rakuten_url = nil
  end

  def self.get_shop_item_hash(text)
    urls = URI.extract(text, %w[http])
    if(!urls.empty?)
      urls.each do |url|
        url = self.expand(URI.parse(url))
        if (url)
          $log.info('[RakutenInfo.get_shop_item_hash] URL: ' + url.to_s)
          #item_id = self.get_item_id(url)

          uri = url.path.split('/')
          uri.reject!{|i| (i.nil? || i.empty?)}

          return nil if(uri.size != 2)
          $log.info('[RakutenInfo.get_shop_item_hash] shop_item_code: ' + uri.join(':'))
          @@rakuten_url = url
          return uri.first + ":" + uri.last
        else
          return nil
        end 
      end
    end
  end

  # textからURL抽出・複数ある場合はそれぞれ見る
  def self.get_rakuten_info(text)
    urls = URI.extract(text, %w[http])
    if(!urls.empty?)
      urls.each do |url|
        $log.info('[RakutenInfo.get_rakuten_info] try to get info from ' + url)
        rakuten_info = self.get_rakuten_info_by_url(url)
        return rakuten_info
        $log.warn('[RakutenInfo.get_rakuten_info] could not get info from ' + url)
      end
    end
    return nil
  end

  # URLから商品情報取得
  def self.get_rakuten_info_by_url(url)
    url = self.expand(URI.parse(url))
    if (url)
      item_id = self.get_item_id(url)
      item_id = self.get_item_id(url) if item_id.nil? # 再チャレンジ

      return nil if item_id.nil?

      uri = url.path.split('/')
      $log.info('[RakutenInfo.get_rakuten_info_by_url]: ' + uri.join(':'))
      
      uri.reject!{|i| (i.nil? || i.empty?)}
      
      return nil if(uri.size != 2)
      #uri.shift
      #{:shop_name => uri.first, :item_name => uri.last}
      $log.info('[RakutenInfo.get_rakuten_info_by_url] uri: ' + uri.join(','))
      rakuten_item_info = self.item_code_api(uri.first, item_id)
      $log.info('[RakutenInfo.get_rakuten_info_by_url] rakuten_item_info: ' + rakuten_item_info.to_s)
      return rakuten_item_info
    else
      nil
    end   
  end

  # 商品コードAPIに問い合せて商品情報を取得
  # item_code = "{shop_name}:{item_id}"
  def self.item_code_api(shop_name, item_id)
    begin
      $log.info('[item_code_api] shop_name:' + shop_name + ', item_id:' + item_id)
    return RakutenItemCodeAPI.fetch(shop_name + ':' + item_id) if(shop_name && item_id)
    rescue => e
      $log.error(e.message + ', ' + e.backtrace.join("\n"))
    end
  end

  # URLの先のHTMLからitem_idを取得
  def self.get_item_id(url)
    $log.info('[RakutenInfo.get_item_id] url:' + url.to_s)
    Net::HTTP.start(url.host, 80) do |http|
      response = http.get(url.path)
      item_id_form = response.body.match(/value="[0-9]{8}" type="hidden" name="item_id"/)
      if(item_id_form)
        return item_id_form.to_a.first.match(/[0-9]{8}/).to_a.first
      end
    end
    $log.warn('[RakutenInfo.get_item_id] could not get item_id. url:' + url.to_s)
    return nil
  end

  # 短縮URLを展開する（広告リンクは除外）
  def self.expand(url, prev_location="", count=0)
    return @@rakuten_url if(@@rakuten_url)
    $log.info('[RakutenInfo.expand] URI:' + url.to_s + ', COUNT:' + count.to_s)
    return nil if(count > 5)
    return nil if (url.to_s.match(/^http:\/\/twitpic\.com/))
    return url if (url.to_s.match(/^http:\/\/item\.rakuten\.co\.jp/))

    if(url.to_s.match(/^http:\/\/hb\.afl\.rakuten\.co\.jp/) || url.to_s.match(/^http:\/\/pt\.afl\.rakuten\.co\.jp/))
      decode_url = URI.decode(url.to_s)
      decode_url = decode_url.match(/http:\/\/item\.rakuten\.co\.jp\/[\w\-]+\/[\w\-]+/)
      return nil unless decode_url
      $log.info('[RakutenInfo.expand] decode_url: ' + decode_url.to_s)
      return URI.parse(decode_url.to_s)
    end

    begin
      http = Net::HTTP.new(url.host, 80)
      http.open_timeout = 5
      http.read_timeout = 20
      http.start do |http|
        response = http.head(url.path).to_hash
        locations = response["location"]
        if(locations)
          locations.each do |location|
            if (location.match(/^http:\/\/item\.rakuten\.co\.jp/))
              return URI.parse(location)
            end
            if(location == url.to_s || location == prev_location)
              return nil
            else
              return self.expand(URI.parse(location), url.to_s, count+1)
            end
          end
        else
          return nil
        end
      end
    rescue Exception => e
      $log.warn(e.message + ', ' + e.backtrace.join(','))
      return nil
    end
  end
end
