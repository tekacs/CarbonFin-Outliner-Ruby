#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__)
require 'carbonfin'

username = '<username>'
password = '<password>'

cfa = CarbonFin::Agent.new
cfa.login(username, password)
cfa.save_cookies
