# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_form/version"

Gem::Specification.new do |s|
  s.name        = "simple_form"
  s.version     = SimpleForm::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Forms made easy!"
  s.email       = "contact@plataformatec.com.br"
  s.homepage    = "http://github.com/plataformatec/simple_form"
  s.description = "Forms made easy!"
  s.authors     = ['José Valim', 'Carlos Antônio']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.test_files   -= Dir["test/support/country_select/**/*"]
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rubyforge_project = "simple_form"

  s.add_dependency('activemodel', '~> 3.0')
  s.add_dependency('actionpack', '~> 3.0')
end
