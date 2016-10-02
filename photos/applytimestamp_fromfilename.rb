#!~/.rbenv/shims/ruby

require 'time'

def updateTimestampFromNameofDropbox (name:, ext:)

  s = File.stat(name)
  # p s.mtime # latest updated time.

  at = s.atime

  ## remove extention & replace words.
  mtimesrc = name.dup
  mtimesrc.slice!(/[\w\s\d\/]+\//)
  mtimesrc.slice!("." + ext)
  mtimesrc.gsub!(".", ":")
  #p mtimesrc
  mt = Time.parse(mtimesrc)

  #p at
  #p mt

  File::utime(at, mt, name)
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

#####
# make a list by searching *.ext
# get current directory

# extension
ext = ".jpg"

location = Dir::pwd

# pick up files
param_of_search = location + "/**/*" + ext

filelist = create_filename_list param_of_search

filelist.each { |f|
  updateTimestampFromNameofDropbox(name: f, ext: ext)
}
