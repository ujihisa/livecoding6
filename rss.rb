require 'erb'
class RSS
  def self.make(hash)
    [:title, :description, :link, :items].each do |x|
      raise unless hash[x]
    end
    template = <<EOF # {{{
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
  xmlns:content="http://purl.org/rss/1.0/modules/content/"
  xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
  <channel>
    <title><%= hash[:title] %></title>
    <link><%= hash[:link] %></link>
    <description><%= hash[:description] %></description>
    <% hash[:items].each do |item| %>
    <item>
      <title><%= item[:title] %></title>
      <link><%= item[:link] %></link>
      <description><%= item[:description] %></description>
      <pubDate><%= item[:date] %></pubDate>
      <dc:date><%= item[:date] %></dc:date>
    </item>
    <% end %>
  </channel>
</rss>
EOF
    # }}}
    ERB.new(template).result(binding)
  end
end

if $0 == __FILE__
  hashes = []
  rss = RSS.make(
    :title => "Recent Commits to livecoding6:master with Diff",
    :description => "Recent Commits to livecoding6:master with Diff",
    :link => "http://ujihisa.github.com/livecoding6/",
    :items => hashes)
  puts rss
end
# vim: foldmethod=marker
