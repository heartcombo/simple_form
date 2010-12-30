source "http://rubygems.org"

gem "rails", "~> 3.0.0"

group :test do
  gem "mocha", :require => false

  if RUBY_VERSION < "1.9"
    gem "ruby-debug", :require => false
  else
    gem "test-unit", :require => false
  end
end
