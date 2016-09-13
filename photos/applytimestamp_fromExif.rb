#!~/.rbenv/shims/ruby

# need to install gem exifr
# gem install exifr
require 'exifr'

def get_info_fromExif (name:, tagname:)
  @exif = EXIFR::JPEG.new(name)  
  # puts @exif.model
  return @exif.send(tagname)
end


def updateTimestampFromExif (name:, ext: "" )
  s = File.stat(name)
  # p s.mtime # latest updated time.
  at = s.atime
  mt = get_info_fromExif(name: name, tagname: "date_time_original")
  p mt
  File::utime(at, mt, name)
end

photoname = "IMG_20150807_162949.jpg"
photoname = "2014-01-08 16.23.23.jpg"

updateTimestampFromExif(name: photoname)

exit

