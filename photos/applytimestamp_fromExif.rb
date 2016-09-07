#!~/.rbenv/shims/ruby

# need to install gem exifr
# gem install exifr
require 'exifr'

photoname = "IMG_20150807_162949.jpg"
photoname = "2014-01-08 16.23.23.jpg"

@exif = EXIFR::JPEG.new(photoname)

p photoname
# camera device name
puts @exif.model

# the date when the photo was taken.
puts @exif.date_time_original


# the aspect of the pixel range
puts @exif.pixel_x_dimension
puts @exif.pixel_y_dimension
