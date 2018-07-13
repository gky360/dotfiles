#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'uri'

url = `pbpaste`.strip
doc = Nokogiri::HTML(open(url, :allow_redirections => :all))
title = doc.title.strip.gsub(/[\s]*(\r\n?|\n)[\s]*/," ")
md_link_text = "[#{title}](#{URI::unescape(url)})"
puts md_link_text
`/bin/echo -n '#{md_link_text}' | pbcopy`
