#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__)
require 'carbonfin'

USAGE = "Usage: delete.rb <name0> <name1> <name2> ..."

def die(msg)
  warn msg
  exit 1
end

die USAGE if ARGV.count < 1

cfa = CarbonFin::Agent.new
die "Please login using login.rb first." unless cfa.login

yes = !ARGV.index('-y').nil?
ARGV.delete '-y'

for name in ARGV
  prompt = "Delete #{name} from server (y/n)? "
  next unless (yes || (print prompt; $stdin.gets.chomp == 'y'))
  cfa.outlines_by_name(name).each { |o| o.delete }
end