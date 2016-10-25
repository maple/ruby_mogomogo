#!~/.rbenv/shims/ruby
# coding: utf-8
### ------------------------------------------
## install geocoder.
# $ gem install geocoder
# Or
## use Google Maps API
# Usage Limits.
# 2,500 free requests / day & 50 req / sec
#
# how to get API key.
# URL:
# API key name:
#
# URL encoding:
#
# for HTTP GET
# usr typhoeus / net-http / open-uri

require 'net/http'
require 'uri'


key = "your api key"
address = "Imperial Palace"
ARGV[0] ? address = ARGV[0] : address
ARGV[1] ? key = ARGV[1] : key

def show_usage
  p "Need parameters placename & apikey"
  p "or change variable \"key\" to your key."
  p "$ #{$0} place_name apikey"
end

if key == "your api key" then
  show_usage
  exit
end


params = URI.encode_www_form({ key: key, address: address })
p params

uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?#{params}")
response = Net::HTTP.get_response(uri)

p response.body

