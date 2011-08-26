#!/usr/bin/env ruby
require './carbonfin.rb'

USAGE = "Usage: delete.rb <name0> <name1> <name2> ..."

def die(msg)
  warn msg
  exit 1
end

die USAGE if ARGV.count < 1

cfa = CFAgent.new
die "Please login using login.rb first." unless cfa.login

for name in ARGV
  cfa.outline_ids_by_name(name).map { |id| cfa.delete(id) }
end