


def get_info_fromExif (name:, tagname:)
  if EXIFR::JPEG.new(name).exif? then   
       @exif = EXIFR::JPEG.new(name)
  else
       return
  end
  #p @exif.model
  found = @exif.model.index("E-PL5")
  if found then
    p "Digital camera photo is found."
  end
    
#  if @exif.model == "E-PL5" then
#    p "Digital camera photo is found."
#  end

  
  # puts @exif.model
  return @exif.send(tagname)
end
