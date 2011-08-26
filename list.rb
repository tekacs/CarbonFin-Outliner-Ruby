#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__)
require 'carbonfin'

USAGE = "Usage: list.rb"

def die(msg)
  warn msg
  exit 1
end

cfa = CarbonFin::Agent.new
die "Please login using login.rb first." unless cfa.login

puts (cfa.outlines.map{ |o| o.name }).join("\n")