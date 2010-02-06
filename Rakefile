require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'simple_form', 'version')

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the simple_form plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the simple_form plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SimpleForm'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "simple_form"
    s.version = SimpleForm::VERSION
    s.summary = "Forms made easy!"
    s.email = "contact@plataformatec.com.br"
    s.homepage = "http://github.com/plataformatec/simple_form"
    s.description = "Forms made easy!"
    s.authors = ['José Valim', 'Carlos Antônio']
    s.files =  FileList["[A-Z]*(.rdoc)", "{generators,lib}/**/*", "init.rb"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install jeweler"
end
