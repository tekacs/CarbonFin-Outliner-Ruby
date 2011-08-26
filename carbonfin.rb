#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'logger'

PW_SALT = '|CarbonFin.Outliner'
COOKIE_FILE = 'cfo.yaml'
BASE_URL = 'https://cfoutliner.appspot.com/'

module CarbonFin

class Agent
  attr_accessor :agent
  
  def initialize
    @agent = Mechanize.new { |a| a.log = Logger.new("cfo.log") }
    @agent.user_agent_alias = 'Mac Safari'
    for format in [:json, :opml, :text, :print]
      define_singleton_method("get_#{format}") { |id| get(id, format) }
    end
  end
  
  def login(username=nil, password=nil)
    if File.exists? COOKIE_FILE
      load_cookies
      return true if logged_in?
    end
    return false if (username.nil? or password.nil?)
    login_url = BASE_URL + "?action=login&userid=#{username}"
    login_url += "&password=#{Digest::SHA1.hexdigest(password + PW_SALT)}"
    @agent.get(login_url) # Get login cookie.
    return logged_in?
  end
  
  def save_cookies
    @agent.cookie_jar.save_as(COOKIE_FILE)
  end
  
  def load_cookies
    @agent.cookie_jar.load(COOKIE_FILE)
  end
  
  def logged_in?
    return get_auth_cookies.count == 1
  end
  
  def upload_file(filename)
    return false unless logged_in?
    page = @agent.get(BASE_URL)
    form = page.form('opmlForm')
    form.file_uploads.first.file_name = filename
    return submit_form(form)
  end
  
  def upload_text(name, text, are_tasks=false)
    return false unless logged_in?
    page = @agent.get(BASE_URL)
    form = page.form('importTextForm')
    form.importName = name
    form.importText = text
    form.checkbox_with(:name => 'importAsTasks').checked = are_tasks
    return submit_form(form)
  end
  
  def outlines
    return false unless logged_in?
    parser = @agent.get(BASE_URL).parser
    spans = parser.css('.outlineListItem span')
    id_pairs = spans.map do |span|
      [(span.parent.attributes['onclick'].value.scan /'(.*:.*?)'/)[0][0],
        span.content]
    end
    id_pairs.map { |id, name| Outline.new(id, name) }
  end
  
  def outlines_by_name(name)
    outlines.select { |o| o.name == name }
  end
  
  def get_by_id(outline_id, format=:opml)
    return false unless logged_in?
    action = (format == :print ? 'get' : 'export') + "_" + format.to_s
    url = BASE_URL + "/?action=#{action}&outlineId=#{outline_id}"
    return @agent.get_file(url)
  end
  
  def delete_by_id(outline_id)
    return false unless logged_in?
    url = BASE_URL + "/?action=delete&outlineId=#{outline_id}"
    begin
      @agent.get(url)
    rescue Mechanize::ResponseCodeError
      return false
    end
    return true
  end
  
  private
  
  def get_auth_cookies
    all = @agent.cookie_jar.cookies(URI.parse(BASE_URL))
    all.select { |x| x.name == 'auth' }
  end
  
  def submit_form(form)
    begin
      @agent.submit(form)
    rescue Mechanize::ResponseCodeError
      return false
    end
    return true
  end
end
  
class Outline
  attr_reader :id
  attr_reader :name
  attr_accessor :agent
  
  def initialize(id, name)
    @id = id
    @name = name
    @agent = Agent.new
    return false unless @agent.login
    for format in [:json, :opml, :text, :print]
      define_singleton_method("get_#{format}") { get(format) }
    end
  end
  
  def ready?
    @agent.logged_in?
  end
  
  def get(format)
    @agent.get_by_id(@id, format)
  end
  
  def delete
    @agent.delete_by_id(@id)
  end
end

end