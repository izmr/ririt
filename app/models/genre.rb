class Genre < ActiveResource::Base
  self.site = "http://api.rakuten.co.jp"
  self.format = :json
  @@developer_id = '24e3e9e429fc555ba72188fc4f79ed80'
  @@affiliate_id = '0ccf16d4.e6b26434.0ccf16d5.11498e3e'
  @@operation    = 'GenreSearch'
  @@version      = '2007-04-11'
  @@from         = '/rws/3.0/json'

  def self.fetch(genre_id)
    self.find(
      :one,
      :from => @@from,
      :params => {
      :developerId => @@developer_id,
      :affiliateId => @@affiliate_id,
      :operation   => @@operation,
      :version     => @@version,
      :genreId   => genre_id
    }
    )
  end
end
