source "https://rubygems.org"
ruby file: ".ruby-version"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "jekyll", "~> 4.4"
gem "webrick"

# Ruby 3.4 moved these out of the default gems. Liquid requires bigdecimal without
# declaring it, and under Bundler an undeclared bundled gem is a LoadError, not a
# warning - the build will not start without it. logger goes the same way in Ruby
# 3.5 and Jekyll does not declare it either; naming it now silences the warning.
gem "bigdecimal"
gem "logger"

# kramdown runs in GFM mode - see `kramdown.input` in _config.yml - and the parser
# ships separately.
gem "kramdown-parser-gfm"

group :jekyll_plugins do
  gem "jekyll-paginate-v2"
  gem "jekyll-tidy"
end

# Windows and JRuby do not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
