# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_form/version"

Gem::Specification.new do |s|
  s.name        = "simple_form"
  s.version     = SimpleForm::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Forms made easy!"
  s.email       = "heartcombo.oss@gmail.com"
  s.homepage    = "https://github.com/heartcombo/simple_form"
  s.description = "Forms made easy!"
  s.authors     = ['José Valim', 'Carlos Antonio', 'Rafael França']
  s.license     = "MIT"
  s.metadata    = {
    "homepage_uri"      => "https://github.com/heartcombo/simple_form",
    "documentation_uri" => "https://rubydoc.info/github/heartcombo/simple_form",
    "changelog_uri"     => "https://github.com/heartcombo/simple_form/blob/main/CHANGELOG.md",
    "source_code_uri"   => "https://github.com/heartcombo/simple_form",
    "bug_tracker_uri"   => "https://github.com/heartcombo/simple_form/issues",
    "wiki_uri"          => "https://github.com/heartcombo/simple_form/wiki"
  }

  s.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.7.0"

  s.add_dependency "activemodel", ">= 7.0"
  s.add_dependency "actionpack", ">= 7.0"

  s.add_development_dependency "country_select"
  s.add_development_dependency "minitest", "< 6"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
end
