#!/home/masayuki/.rbenv/shims/ruby

require 'time'

# sample file of Dropbox
fname = "2016-08-28 10.36.50.jpg"
ext = "jpg"

s = File.stat(fname)
p s.atime # latest accessed time.
p s.mtime # latest updated time.



# modify timestamp.

at = s.atime

## remove extention.
mtimesrc = fname.dup
mtimesrc.slice!("." + ext)
mtimesrc.gsub!(".", ":")
#p mtimesrc

mt = Time.parse(mtimesrc)

p mt
p at

# File::utime(at, mt, fname)



