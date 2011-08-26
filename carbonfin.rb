#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'logger'

PW_SALT = '|CarbonFin.Outliner'
COOKIE_FILE = 'cfo.yaml'
BASE_URL = 'https://cfoutliner.appspot.com/'

class CFAgent

  attr_accessor :agent

  def initialize
    @agent = Mechanize.new { |a| a.log = Logger.new("cfo.log") }
    @agent.user_agent_alias = 'Mac Safari'
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
  
  def submit_form(form)
    begin
      @agent.submit(form)
    rescue Mechanize::ResponseCodeError
      return false
    end
    return true
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
  
  def outline_names
    return false unless logged_in?
    parser = @agent.get(BASE_URL).parser
    spans = parser.css('.outlineListItem span')
    return spans.map { |x| x.content }
  end
  
  def outline_ids_by_name(name)
    return false unless logged_in?
    parser = @agent.get(BASE_URL).parser
    spans = parser.css('.outlineListItem span')
    selected = spans.select { |x| x.content == name }
    onclick = selected.map { |x| x.parent.attributes['onclick'].value}
    ids = onclick.map { |x| (x.scan /'(.*:.*?)'/)[0][0] }
    return ids
  end
  
  def get(outline_id, format=:opml)
    return false unless logged_in?
    action = (format == :print ? 'get' : 'export') + "_" + format.to_s
    url = BASE_URL + "/?action=#{action}&outlineId=#{outline_id}"
    return @agent.get_file(url)
  end
  
  def get_json(outline_id)
    return get(outline_id, :json)
  end
  
  def get_opml(outline_id)
    return get(outline_id, :opml)
  end
  
  def get_text(outline_id)
    return get(outline_id, :text)
  end
  
  def get_print(outline_id)
    return get(outline_id, :print)
  end
  
  def delete(outline_id)
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

end