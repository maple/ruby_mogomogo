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
# URL on google:
#
# URL encoding:
#
# for HTTP GET
# usr typhoeus / net-http / open-uri
#
# to handle JSON
# jq is better.

require 'net/http'
require 'uri'
require "mini_exiftool"

require 'json'

key = "your api key"
address = "Imperial Palace"


ARGV[0] ? address = ARGV[0] : address
ARGV[1] ? key = ARGV[1] : key

def show_usage
  printf "Need parameters placename & apikey"
  puts "or rewrite variable \"key\" to your key."
  puts "$ #{$0} \[place_name\] \[apikey\]"
end

if key == "your api key" then
  show_usage
  exit
end


params = URI.encode_www_form({ key: key, address: address })
p params

uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?#{params}")
response = Net::HTTP.get_response(uri)

# p response.body

json_data = JSON.parse(response.body)
p json_data['results'][0]['formatted_address']      # for debug
lat = json_data['results'][0]['geometry']['location']["lat"]
lng = json_data['results'][0]['geometry']['location']["lng"]

p "lat = (#{lat})" 
p "lng = (#{lng})" 

def set_location_info_to_exiftags (lat: , lng: , file: )
  photo = MiniExiftool.new file.to_s
  photo.gps_latitude = lat
  photo.gps_latitude_ref = "North" # base on Japan
  photo.gps_longitude = lng
  photo.gps_longitude_ref = "E" # base on Japan

  begin
    photo.save!
    puts "done to rewrite exif for location : (#{file})"
  rescue => e
    puts e
  end
end

# create filelist

def create_filename_list (param)
  ar = []
  Dir::glob(param, File::FNM_CASEFOLD){|f|
    next unless FileTest.file?(f)
    ar << f
  }
  return ar
end

# extension
ext = ".jpg"
location = Dir::pwd

# pick up files
param_of_search = location + "/**/*" + ext

filelist = create_filename_list param_of_search

filelist.each { |f|
  # keep a time stamp of the file.
  origintime = File.stat(f).mtime
  set_location_info_to_exiftags lat: lat, lng: lng, file:f
  File::utime(origintime, origintime, f) 
}
