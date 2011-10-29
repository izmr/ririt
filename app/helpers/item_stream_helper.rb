module ItemStreamHelper
  def title_info(count, limit, page)
    title = ''
    if count && count.to_s.match(/\d+/) && count.to_i != 3
      title += " #{count} Tweet以上"
    end
    if limit && limit.to_s.match(/\d+/) && limit.to_i != 10
      title += " #{limit} 商品ずつ"
    end
    if page && page.to_s.match(/\d+/) && page.to_i != 0
      title += " #{page} ページ目"
    end
    return title
  end
end
