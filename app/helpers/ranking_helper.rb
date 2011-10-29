require 'jcode'

module RankingHelper
  def date_title(date)
    date_format(date) unless date == Date.today
  end
  def date_format(date)
    date.strftime("%Y年%m月%d日")
  end
  def wbr(str)
    result = ''
    str.each_char do |char|
      result += char + '<wbr />'
    end
    result
  end

  def cut_str(str, len)
    if str != nil
      if str.jlength < len
        str
      else
        str.scan(/^.{#{len}}/m)[0] + "..."
      end
    else
      ''
    end
  end
end
