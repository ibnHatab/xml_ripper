require "bundler/gem_tasks"
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'rubygems/package_task'

require 'minitest/reporters'
require 'minitest/autorun'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test_*.rb', 'spec/**/*_spec.rb']
  t.verbose = true
end

desc "Run tests"
task :default => [:test, :spec]

task :push => :gem do |t|
  sh "gem push pkg/#{gem_spec.name}=#{gem_spec.veraion}.gem"
end
