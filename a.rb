require 'rss/maker'

gl = `git log -u README.md`.lines.inject([]) {|sofar, line|
  line = line.gsub('@gmail.com', ' at gmail com')
  if /^commit/ =~ line
    sofar + [line]
  else
    sofar.last << line
    sofar
  end
}
hash = gl.map {|commit|
  commit = commit.lines.to_a
  hash = {}
  hash[:commit] = commit.shift.chomp.match(/commit (.*)/)[1]
  commit.shift if /^Merge/ =~ commit[0]
  hash[:author] = commit.shift.chomp.match(/Author:\s*(.*)/)[1]
  hash[:date] = commit.shift.chomp.match(/Date:\s*(.*)/)[1]

  {
    :title => hash[:commit],
    :link => hash[:commit],
    :date => Time.parse(hash[:date]),
    :description => '<![CDATA[' + commit.join + ']]>'
  }
}

content = RSS::Maker.make('2.0') do |m|
  m.channel.title = "Recent Commits to livecoding6:master with Diff"
  m.channel.description = "Recent Commits to livecoding6:master with Diff"
  m.channel.link = "http://ujihisa.github.com/livecoding6/"
  #m.items.do_sort = true

  hash.each do |h|
    i = m.items.new_item
    i.title = h[:title]
    i.link = h[:link]
    i.date = h[:date]
    i.description = h[:description]
  end
end

puts content
