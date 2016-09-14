#!~/.rbenv/shims/ruby

# need to install gem exifr
# gem install exifr
require 'exifr'


def get_image_extension(local_file_path)
  png = Regexp.new("\x89PNG".force_encoding("binary"))
  jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
  jpg2 = Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary")) 
  case IO.read(local_file_path, 10)
  #case File.open(local_file_path).read(10)
  when /^GIF8/
       'gif'
  when /^#{png}/
         'png'
  when /^#{jpg}/
         'jpg'
  when /^#{jpg2}/
         'jpg'
  else
    mime_type = `file #{local_file_path} --mime-type`.gsub("\n", '')
    # p mime_type
    raise UnprocessableEntity, "unknown file type" if !mime_type
    #mime_type.split(':')[1].split('/')[1].gsub('x-', '').gsub(/jpeg/, 'jpg').gsub(/text/, 'txt').gsub(/x-/, '')
    mime_type.split(':')[1].gsub('x-', '').gsub(/jpeg/, 'jpg').gsub(/text/, 'txt').gsub(/x-/, '')
  end
end


def get_info_fromExif (name:, tagname:)
  if EXIFR::JPEG.new(name).exif? then   
       @exif = EXIFR::JPEG.new(name)
  else
       return
  end
  
  # puts @exif.model
  return @exif.send(tagname)
end


def updateTimestampFromExif (name:, ext: "" )
  s = File.stat(name)
  # p s.mtime # latest updated time.
  at = s.atime
  mt = get_info_fromExif(name: name, tagname: "date_time_original")
  p mt.class
  #File::utime(at, mt, name)
end


# enable to find in sub-directories.
def create_filename_list (param)
  ar = []
  Dir::glob(param){|f|
    next unless FileTest.file?(f)
    #ar << "#{File.basename(f)} : #{File::stat(f).size}"
    ar << f
  }
  return ar
end


ext = "jpg"
location = Dir::pwd
# pick up files
param_of_search = location + "/**/*" + ext
filelist = create_filename_list param_of_search

filelist.each { |f|
  p f
  # verify the file type of file.
  if get_image_extension(f) == "jpg" then
    updateTimestampFromExif name: f
  end
}

exit

