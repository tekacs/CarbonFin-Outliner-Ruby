#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__)
require 'carbonfin'

USAGE = "Usage: upload.rb <file0.opml> <file1.opml> <file2.opml> ..."
OPML_WARNING = "Warning: You should only upload OPML."

def die(msg)
  warn msg
  exit 1
end

die USAGE if ARGV.count == 0

cfa = CarbonFin::Agent.new
die "Please login using login.rb first." unless cfa.login

for filename in ARGV
  if File.exists? filename
    warn OPML_WARNING if (File.extname filename) != '.opml'
    cfa.upload_file(filename)
  end
end