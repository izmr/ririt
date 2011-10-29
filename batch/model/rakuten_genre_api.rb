require 'rubygems'
require 'active_resource'

class RakutenGenreAPI < ActiveResource::Base
  self.site = "http://api.rakuten.co.jp"
  self.format = :json
  @@developer_id = '*****************'
  @@affiliate_id = '*****************'
  @@operation    = 'GenreSearch'
  @@version      = '2007-04-11'
  @@from         = '/rws/3.0/json'

  def self.fetch(genre_id)
    begin
      #$log.info('[RakutenGenreAPI.fetch] genre_id:' + genre_id)
      self.find(
        :one,
        :from => @@from,
        :params => {
          :developerId => @@developer_id,
          :affiliateId => @@affiliate_id,
          :operation   => @@operation,
          :version     => @@version,
          :genreId   => genre_id,
          :genrePath => 1
        }
      )
    rescue => e
      #$log.error('genre_id was broken:' + e.message + ':' + e.backtrace.join(','))
      p 'genre_id was broken:' + e.message + ':' + e.backtrace.join(',')
    end
  end
end
