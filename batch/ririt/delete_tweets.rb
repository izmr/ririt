$KCODE = 'UTF-8'

require '../model/tables.rb'
require 'pp'

pp Tweet.find(:all, :limit => 10)
