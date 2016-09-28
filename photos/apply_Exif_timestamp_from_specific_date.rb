#!~/.rbenv/shims/ruby
### ---------------------------------
# need to install gem of mini_exiftool & exiftool
# 
# gem install mini_exiftool
#   Also install exiftool http://www.sno.phy.queensu.ca/~phil/exiftool/
#
## usage:
# $ ruby apply_Exif_timestamp_from_specific_date.rb [time]
# if user doesn't put argument as a date, this program uses current time.
#
## background
# I have a lot of scan data to keep my memory as digital data.
# such as photos of paper, pictures my children drew, brochure of a traveling and so on.
# I noticed I'm almost forgetting when I took these photos, when my son drew or when my family has visited that place of the brochure.
# To keep information of timestamp will help me in the future, therefore I've written this code. ;)
#

require "mini_exiftool"

def set_timestamp_to_exiftags (time: , file: )
  photo = MiniExiftool.new file.to_s
  # p photo.date_time_original
  photo.date_time_original = time
  photo.modify_date = time  # date time
  photo.create_date = time  # date time digitized

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
  # Dir class support upcase & lowercase letter on ruby v2.2. i.e: jpg, JPG.
  Dir::glob(param){|f|
    next unless FileTest.file?(f)
    #ar << "#{File.basename(f)} : #{File::stat(f).size}"
    ar << f
  }
  return ar
end

# set start time.
ARGV[0] ? date = ARGV[0] : date = Time.now.to_s

# extension
ext = "jpg"
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
