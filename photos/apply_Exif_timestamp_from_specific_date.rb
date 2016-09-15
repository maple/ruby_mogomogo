#!~/.rbenv/shims/ruby

### ---------------------------------
# need to install gem of mini_exiftool & exiftool
# 
# gem install mini_exiftool

require "mini_exiftool"

def set_timestamp_to_exiftags (time: , file: )
  photo = MiniExiftool.new file.to_s
  p photo.date_time_original
  photo.date_time_original = time

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
  Dir::glob(param){|f|
    next unless FileTest.file?(f)
    #ar << "#{File.basename(f)} : #{File::stat(f).size}"
    ar << f
  }
  return ar
end

# set start time.
ARGV[1] ? date = ARGV[1] : date = "201601011200"
  
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
