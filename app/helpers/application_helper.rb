require 'cgi'
$KCODE = 'u'

module ApplicationHelper
  def number_format(number)
    return number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse + ' 円(税込)'
  end
  def item_name_format(item_name, cut_num = 25)
    terminal = ''

    item_name.gsub!(/【[^】]*?楽天.*?】/, '')
    item_name.gsub!(/【[^】]*?送料.*?】/, '')
    item_name.gsub!(/【[^】]*?無料.*?】/, '')
    item_name.gsub!(/【[^】]*?あす楽.*?】/, '')
    item_name.gsub!(/【[^】]*?smtb.*?】/, '')
    item_name.gsub!(/【[^】]*?マラソン.*?】/, '')
    item_name.gsub!(/【[^】]*?楽ギフ.*?】/, '')

    terminal = '...' if item_name.split(//u).size > cut_num
    return item_name.split(//u)[0,cut_num].to_s + terminal
  end
  def rakuten_genre_search(genre_id, shop_name = nil)
    url = 'http://hb.afl.rakuten.co.jp/hgc/0ae3d0c1.57c4d431.0ae3d0c1.57c4d431/_RTogcl10000001?pc=http%3A%2F%2Fecustom.listing.rakuten.co.jp%2Frms%2Fsd%2Fecustom%2Fmall%3Fnm%3D%25E3%2580%258CRiriT%2B-%2BTwitter%25E3%2581%25A7%25E8%25A9%25B1%25E9%25A1%258C%25E3%2581%25AE%25E5%2595%2586%25E5%2593%2581%25E3%2583%25A9%25E3%2583%25B3%25E3%2582%25AD%25E3%2583%25B3%25E3%2582%25B0%25E3%2580%258D%26bk%3Dririt.marimofire.com%26hd%3D%26cl%3DC00012%26aid%3D0ae3d0c1.57c4d431%26v%3D3'
    url += '%26g%3D' + genre_id.to_s unless genre_id.nil?
    url += '%26sw%3D' + CGI.escape(shop_name) unless shop_name.nil?

    return url
  end
  def twitter_format(text)
    return text.gsub(/@(\w+)/) { '<a href="http://twitter.com/' + $1 + '">@' + $1 + '</a>' }
  end
  def count_set(count, now_count)
    if count.to_i == now_count.to_i
      return "#{count.to_s} tweet以上"
    else
      return link_to("#{count.to_s} tweet以上", url_for(:controller => 'item_stream', :count => count, :page => @page.to_i, :search_word => @search_word, :limit => @limit))
    end
  end

  def random_banner
    banners = []

    banners.push <<EOS
    <a href="http://hb.afl.rakuten.co.jp/hsc/0d386564.fe6cc23f.0d386561.16afe521/" target="_blank"><img src="http://hbb.afl.rakuten.co.jp/hsb/0d386564.fe6cc23f.0d386561.16afe521/166766/" border="0"></a>
EOS
    banners.push <<EOS
    <a href="http://hb.afl.rakuten.co.jp/hsc/0d4a47d9.6ccc101e.0d4a47d6.9c5e80ff/" target="_blank"><img src="http://hbb.afl.rakuten.co.jp/hsb/0d4a47d9.6ccc101e.0d4a47d6.9c5e80ff/389072/" border="0"></a>
EOS
    return banners.at(rand(banners.size))
  end

  def random_landscape_banner
    banners = []

   # banners.push <<EOS
   # <a href="http://hb.afl.rakuten.co.jp/hsc/0d4a47d7.ddf71b96.0d4a47d6.9c5e80ff/" target="_blank"><img src="http://hbb.afl.rakuten.co.jp/hsb/0d4a47d7.ddf71b96.0d4a47d6.9c5e80ff/389072/" border="0"></a>
#EOS

#    banners.push <<EOS
#    <a href="http://hb.afl.rakuten.co.jp/hsc/0d386562.bccc4083.0d386561.16afe521/" target="_blank"><img src="http://hbb.afl.rakuten.co.jp/hsb/0d386562.bccc4083.0d386561.16afe521/166766/" border="0"></a>

#EOS

    banners.push <<EOS
    <!-- Rakuten Widget FROM HERE --><script type="text/javascript">rakuten_design="circle";rakuten_affiliateId="0ae3d0c1.57c4d431.0ae3d0c2.3047f448";rakuten_items="ctsmatch";rakuten_genreId=0;rakuten_size="600x200";rakuten_target="_blank";rakuten_theme="gray";rakuten_border="off";rakuten_auto_mode="off";rakuten_genre_title="off";rakuten_recommend="on";rakuten_ver="20100708";</script><script type="text/javascript" src="http://xml.affiliate.rakuten.co.jp/widget/js/rakuten_widget.js"></script><!-- Rakuten Widget TO HERE -->
EOS
    return banners.at(rand(banners.size))
  end

  def random_long_banner
    banners = []
    banners.push <<EOS
    <script type="text/javascript"><!--
    google_ad_client = "pub-9868919024784576";
    /* 120x600, 作成済み 11/01/01 */
    google_ad_slot = "9796889195";
    google_ad_width = 120;
    google_ad_height = 600;
    //-->
    </script>
    <script type="text/javascript"
    src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
    </script>
EOS

    return banners.at(rand(banners.size))
  end
end
