#!/usr/bin/env ruby
require './carbonfin.rb'

USAGE = "Usage: download.rb <format> <name>"

def die(msg)
  warn msg
  exit 1
end

die USAGE if ARGV.count < 2
FORMAT = ARGV[0].to_sym

cfa = CarbonFin::Agent.new
die "Please login using login.rb first." unless cfa.login

def ext(format)
  return :html if format == :print
  return :txt if format == :text
  return format
end

for name in ARGV[1, ARGV.length]
  outline = cfa.outlines_by_name(name)[0]
  open("#{name}.#{ext(FORMAT)}", 'w') do |f|
    f.write(outline.get(FORMAT))
  end
end