# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple_form}
  s.version = "1.0.4"
  s.authors = ["Jos\303\251 Valim", "Carlos Ant\303\264nio"]
  s.date = %q{2010-10-08}
  s.description = %q{Forms made easy!}
  s.email = %q{contact@plataformatec.com.br}
  s.homepage = %q{http://github.com/plataformatec/simple_form}
  s.rdoc_options = ["--charset=UTF-8"]
  s.summary = %q{Forms made easy!}

  s.extra_rdoc_files = [ "README.rdoc" ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end

