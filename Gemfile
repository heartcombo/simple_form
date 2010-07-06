source "http://rubygems.org"

if File.exist? File.expand_path('../../rails', __FILE__)
  gem "rails", :path => "../rails"
else
  gem "rails", :git => "git://github.com/rails/rails.git"
end

gem "mocha"

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "test-unit"
end