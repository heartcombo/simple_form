# encoding: UTF-8

require 'bundler/gem_tasks'

require 'rake/testtask'

desc 'Default: run unit tests.'
task default: :test

desc 'Test the simple_form plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

begin
  require 'rdoc/task'
  desc 'Generate documentation for the simple_form plugin.'
  RDoc::Task.new(:rdoc) do |rdoc|
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title    = 'SimpleForm'
    rdoc.options << '--line-numbers'
    rdoc.rdoc_files.include('README.md')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
  puts 'RDoc::Task is not supported on this platform'
end
