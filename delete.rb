#!/usr/bin/env ruby
require './carbonfin.rb'

USAGE = "Usage: delete.rb <name0> <name1> <name2> ..."

def die(msg)
  warn msg
  exit 1
end

die USAGE if ARGV.count < 1

cfa = CarbonFin::Agent.new
die "Please login using login.rb first." unless cfa.login

for name in ARGV
  cfa.outlines_by_name(name).map { |o| o.delete }
end