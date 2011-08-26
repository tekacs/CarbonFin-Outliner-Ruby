#!/usr/bin/env ruby
require './carbonfin.rb'

username = '<username>'
password = '<password>'

cfa = CFAgent.new
cfa.login(username, password)
cfa.save_cookies