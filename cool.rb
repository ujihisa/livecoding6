@body = `pandoc README.md`

if __FILE__ == $0
  if false # TODO: If gh-pages isn't exist
    system "git checkout origin/gh-pages -b gh-pages"
  else
    system "git checkout gh-pages"
  end
  system "git merge master"
  system "erb -r #{__FILE__} -T - -P index.erb > index.html"
  system "git add index.html"
  system "git commit -m 'Automatically updated index.html'"
  system "git push"
  system "git checkout master"
end
