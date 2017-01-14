#!~/.rbenv/shims/ruby
## Background
# There are many pics in my storage and they are from several devices such as Digital Camera (include a mirrorless, a single-lens reflex camera), smart phones, tablets.
# I'd like to delete some pics from Digital Camera to save my storage since these pics are already backed up on other storage (online).
#
# method
# 1. check exif tags of a pic file, the field name is "model".
# 2. if the model includes "Camera's name", delete the file.
#
# here is sample below, my camera is "Olympus E-PL5"

require 'exifr'

modelname = "E-PL5"

def create_filename_list (param)
  ar = []
  # Dir class support upcase & lowercase letter on ruby v2.2. i.e: jpg, JPG.
  Dir::glob(param, File::FNM_CASEFOLD){|f|
    next unless FileTest.file?(f)
    ar << f
  }
  return ar
end


def get_info_fromExif (name:, tagname:)
  if EXIFR::JPEG.new(name).exif? then   
       @exif = EXIFR::JPEG.new(name)
  else
       return
  end
  #p @exif.model
  return @exif.send(tagname)
end


# extension
ext = "jpg"
location = Dir::pwd


# pick up files
param_of_search = location + "/**/*" + ext

filelist = create_filename_list param_of_search

filelist.each { |f|
  modelinfo = get_info_fromExif name: f, tagname: "model"
  p modelinfo
  if modelinfo.instance_of?(String) then
    if modelinfo.index(modelname) then
      p "Digital camera photo is found."
      # delete files
      File.unlink f
    end
  else
    p "This file doesn't include Exif header."
  end
}

