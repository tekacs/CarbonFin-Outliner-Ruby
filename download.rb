#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__)
require 'carbonfin'

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

def write(name, content)
  open("#{name}.#{ext(FORMAT)}", 'w') do |f|
    f.write(content)
  end
end

if ARGV[1] == 'ALL'
  outlines = cfa.outlines
  outlines.each { |o| write(o.name, o.get(FORMAT)) }
end

for name in ARGV[1, ARGV.length]
  outline = cfa.outlines_by_name(name)[0]
  write(name, outline.get(FORMAT))
end