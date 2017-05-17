# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_form/version"

Gem::Specification.new do |s|
  s.name        = "simple_form"
  s.version     = SimpleForm::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Forms made easy!"
  s.email       = "opensource@plataformatec.com.br"
  s.homepage    = "https://github.com/plataformatec/simple_form"
  s.description = "Forms made easy!"
  s.authors     = ['José Valim', 'Carlos Antônio', 'Rafael França']
  s.license     = "MIT"

  s.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  s.test_files    = Dir["test/**/*.rb"]
  s.test_files   -= Dir["test/support/country_select/**/*"]
  s.require_paths = ["lib"]

  s.rubyforge_project = "simple_form"

  s.add_dependency('activemodel', '> 4', '< 5.2')
  s.add_dependency('actionpack', '> 4', '< 5.2')
end
