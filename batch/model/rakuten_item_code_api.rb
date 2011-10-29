require 'rubygems'
require 'active_resource'

class RakutenItemCodeAPI < ActiveResource::Base
  self.site = "http://api.rakuten.co.jp"
  self.format = :json
  @@developer_id = '***'
  @@affiliate_id = '***'
  @@operation    = 'ItemCodeSearch'
  @@version      = '2010-08-05'
  @@from         = '/rws/3.0/json'

  def self.fetch(item_code)
    begin
      $log.info('[RakutenItemCodeAPI.fetch] item_code:' + item_code)
      self.find(
        :one,
        :from => @@from,
        :params => {
          :developerId => @@developer_id,
          :affiliateId => @@affiliate_id,
          :operation   => @@operation,
          :version     => @@version,
          :itemCode   => item_code
        }
      )
    rescue => e
      $log.error('item_code was broken:' + e.message + ':' + e.backtrace.join(','))
    end
  end
end
