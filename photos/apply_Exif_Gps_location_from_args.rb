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
#
# to handle JSON
# jq is better.

require 'net/http'
require 'uri'

require 'json'

key = "your api key"
address = "Imperial Palace"
ARGV[0] ? key = ARGV[0] : key
ARGV[1] ? address = ARGV[1] : address

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

# p response.body

json_data = JSON.parse(response.body)
#p json_data.class
p json_data['results'][0]['formatted_address']
p json_data['results'][0]['geometry']['location']["lat"]
p json_data['results'][0]['geometry']['location']["lng"]


require "mini_exiftool"

def set_timestamp_to_exiftags (time: , file: )
  photo = MiniExiftool.new file.to_s
  # p photo.date_time_original
  # photo.date_time_original = time
  # photo.modify_date = time  # date time
  # photo.create_date = time  # date time digitized
  p "Version ==============================--"
  p photo.GPS_Version_ID
  p photo.gps_latitude
  p photo.gps_latitude_Ref
  p photo.gps_longitude
  p photo.gps_longitude_Ref

  return
  begin
    photo.save!
    puts "done to rewrite exif timestamp : (#{file})"
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


# set start time.
ARGV[3] ? date = ARGV[0] : date = Time.now.to_s

# extension
ext = ".jpg"
location = Dir::pwd

# pick up files
param_of_search = location + "/**/*" + ext

filelist = create_filename_list param_of_search

localtime = Time.parse(date)

filelist.each { |f|
  set_timestamp_to_exiftags file:f, time: localtime
  File::utime(localtime, localtime, f)
  localtime = localtime + 10
}
