#!/usr/bin/env ruby
require './carbonfin.rb'

USAGE = "Usage: list.rb"

def die(msg)
  warn msg
  exit 1
end

cfa = CFAgent.new
die "Please login using login.rb first." unless cfa.login

puts cfa.outline_names.join("\n")