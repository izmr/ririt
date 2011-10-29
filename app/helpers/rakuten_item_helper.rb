module RakutenItemHelper
  def tweet_text_class(date)
    if date.year == Date.today.year && date.month == Date.today.month && date.day == Date.today.day
      return 'today'
    else
      return 'other_day'
    end
  end
end
