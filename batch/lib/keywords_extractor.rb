require 'rubygems'
require 'httpclient'
require 'rexml/document'

class KeywordExtractor
  @@site = "http://jlp.yahooapis.jp"
  @@appid = 'R3BkrhKxg66obNgz9GWAs6DwbZkcNtq27NnsnfXDcs1iL3Kww69Teud.7uV.ACcKNQ--'
  @@output = 'xml'
  @@from = '/KeyphraseService/V1/extract'
  @@waste_expressions = /送料|メール便|[MLS]サイズ|あす楽|smtb|最安値/

  def self.get(text)
    uri = @@site + @@from
    options = {
      :output => @@output,
      :appid => @@appid,
      :sentence => text
    }

    begin
      #$log.info('[RakutenItemCodeAPI.fetch] item_code:' + item_code)
      xml_string = HTTPClient.new.get_content uri, options
      phrases = {}
      doc = REXML::Document.new(xml_string)
      doc.elements.each("/ResultSet/Result"){|e|
        phrases[e.text("Keyphrase")] = e.text("Score").to_i
      }
      phrases.each do |phrase, score|
        phrases[phrase] -= 100 if phrase.match @@waste_expressions
      end
      return phrases
    rescue => e
      #$log.error('item_code was broken:' + e.message + ':' + e.backtrace.join(','))
    end
  end
end
