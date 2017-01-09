#!~/.rbenv/shims/ruby


require 'exifr'

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
    if modelinfo.index("E-PL5") then
      p "Digital camera photo is found."
      # delete files
      File.unlink f
    end
  else
    p "This file doesn't include Exif header."
  end
}

