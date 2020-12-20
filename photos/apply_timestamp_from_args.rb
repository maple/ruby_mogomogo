#!~/.rbenv/shims/ruby
#
## usage:
# $ ruby apply_timestamp_from_args.rb [time]
# ex.) $ ruby apply_timestamp_from_args.rb 20170101
# If a user doesn't put argument as a date, this program uses current time.
#

require "time"

def create_filename_list (param)
  ar = []
  # Dir class support upcase & lowercase letter on ruby v2.2. i.e: jpg, JPG.
  Dir::glob(param){|f|
    next unless FileTest.file?(f)
    #ar << "#{File.basename(f)} : #{File::stat(f).size}"
    ar << f
  }
  return ar.sort
end

# set start time.
ARGV[0] ? date = ARGV[0] : date = Time.now.to_s

# extension
ext = "JPG"
location = Dir::pwd

# pick up files
param_of_search = location + "/**/*" + ext
filelist = create_filename_list param_of_search
localtime = Time.parse(date)

filelist.each { |f|
  File::utime(localtime, localtime, f)
  localtime = localtime + 10
}
