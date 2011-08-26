#!/usr/bin/env ruby
require './carbonfin.rb'

USAGE = "Usage: upload.rb <file0.opml> <file1.opml> <file2.opml> ..."

def die(msg)
  warn msg
  exit 1
end

die USAGE if ARGV.count == 0

cfa = CFAgent.new
die "Please login using login.rb first." unless cfa.login

for filename in ARGV
  if File.exists? filename
    cfa.upload_file(filename)
  end
end