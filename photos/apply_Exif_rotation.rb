#!~/.rbenv/shims/ruby
### ---------------------------------

require "mini_exiftool"

def set_orientation_to_exiftags (rt: , file: )
  p file
  photo = MiniExiftool.new file.to_s
  p photo.orientation
  # GPSMapDatum
  # photo.orientation ="Rotate 270 CW"
  # photo.orientation ="Rotate 90 CW"
  photo.orientation ="Rotate 180"

  # check width / height
  if photo.image_width > photo.image_height
    
  end
  
  begin
    # photo.save!
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


# extension
ext = ".jpg"
location = Dir::pwd

# pick up files
param_of_search = location + "/**/*" + ext

filelist = create_filename_list param_of_search

filelist.each { |f|
  set_orientation_to_exiftags file: f, rt: "hoge"
  p f
}
