#!/home/masayuki/.rbenv/shims/ruby

require 'time'

def updateTimestampFromNameofDropbox (name:, ext:)

  s = File.stat(name)
  p s.atime # latest accessed time.
  p s.mtime # latest updated time.

  at = s.atime

  ## remove extention & replace words.
  mtimesrc = name.dup
  mtimesrc.slice!("." + ext) #.gsub!(".", ":")
  mtimesrc.gsub!(".", ":")
  p mtimesrc

  mt = Time.parse(mtimesrc)

  p at
  p mt

  #File::utime(at, mt, fname)
end
  
# sample file of Dropbox
fname = "2016-08-28 10.36.50.jpg"
ext = "jpg"

updateTimestampFromNameofDropbox(name: fname, ext: ext)



