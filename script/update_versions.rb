#!/usr/bin/env ruby

SOURCE = "https://cakemarketing.zendesk.com/hc/en-us/articles/200704900-Admin-API-Version-Tracker"

require 'net/https'
require 'bundler/setup'
require 'nokogiri'
require 'active_support/core_ext/string'
require 'yaml'

uri = URI.parse(SOURCE)

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)

html = Nokogiri::HTML.parse(response.body)
versions = {}

html.css('div.article-body table').each do |table|
  section_head = table.previous_element
  # Find the section title in the previous elements
  until section_head.text[/\w+/][/^[A-Z]+$/]
    section_head = section_head.previous_element
  end
  section = section_head.text[/\w+/].downcase.to_sym
  versions[section] = {}
  table.css('tr')[1..-1].each do |row|
    version, method = row.css('td').map(&:text)
    method = method[/\w+/]
    next if method.blank?
    method = method.underscore.to_sym
    versions[section][method] = version.to_i
  end
end

File.open("api_versions.yml", "w") {|f| f << YAML.dump(versions) }
