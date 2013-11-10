#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require './setting.rb'

module Downloader
  def self.get_csv
    project_id = Settings.pivotal_tracker.project_id

    agent = Mechanize.new
    page = agent.get("https://www.pivotaltracker.com/projects/#{project_id}/export")

    sign_in = page.forms.first
    sign_in.field_with(:name => 'credentials[username]').value = Settings.pivotal_tracker.user_id
    sign_in.field_with(:name => 'credentials[password]').value = Settings.pivotal_tracker.password
    export_page = agent.submit(sign_in, sign_in.buttons.first)
    export_form = export_page.forms.find { |form| form.action == "/projects/#{project_id}/export" }
    csv = agent.submit(export_form, export_form.buttons.first)
    csv.content
  end
end
