require "bundler/gem_tasks"

require 'rake'
require 'rake/clean'
require 'rake/testtask'

Rake::TestTask.new do |t|
   #t.libs << 'test'
   t.warning = true
   t.verbose = true

   list = ['test/test_net_ping*.rb']

   t.test_files = FileList.new(list)
end

task :default => :test
