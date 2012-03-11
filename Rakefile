# encoding: UTF-8

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
require 'rdoc/task'

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
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SimpleForm'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


namespace :coverage do
 
  task :clean do
    rm_f "test/coverage"
    rm_f "test/coverage.data"
    Rcov = "cd test && rcov  --aggregate coverage.data -Ilib \
                   --text-summary -x 'gems/*,test_helper.rb'"
  end
 
  def display_coverage
    system("sensible-browser test/coverage/index.html")
  end
 
  desc 'All unit test coverage'
  task :all => :clean do
    system("#{Rcov} --html */*_test.rb")
    display_coverage
  end
  
 
end
 
task :coverage do
  Rake::Task["coverage:all"].invoke
end
