require 'time'
require 'cgi'
require './rss'

gl = `git log -u README.md`.lines.inject([]) {|sofar, line|
  line = line.gsub('@gmail.com', ' at gmail com')
  if /^commit/ =~ line
    sofar + [line]
  else
    sofar.last << line
    sofar
  end
}
hashes = gl.map {|commit|
  commit = commit.lines.to_a
  hash = {}
  hash[:commit] = commit.shift.chomp.match(/commit (.*)/)[1]
  commit.shift if /^Merge/ =~ commit[0]
  hash[:author] = commit.shift.chomp.match(/Author:\s*(.*)/)[1]
  hash[:date] = commit.shift.chomp.match(/Date:\s*(.*)/)[1]

  desc = CGI.escapeHTML(commit.join)
  {
    :title => hash[:commit],
    :link => "http://ujihisa.github.com/livecoding6/",
    :date => Time.parse(hash[:date]),
    :description => '<![CDATA[<pre>' + desc + '</pre>]]>'
  }
}

puts RSS.make(
    :title => "Recent Commits to livecoding6:master with Diff",
    :description => "Recent Commits to livecoding6:master with Diff",
    :link => "http://ujihisa.github.com/livecoding6/",
    :items => hashes)
