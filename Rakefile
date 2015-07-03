require 'bundler/gem_tasks'
require 'rake/testtask'
require 'inch/rake'
require 'yard'
require 'rubocop/rake_task'

Rake::TestTask.new(:test) do |t|
  t.libs.push 'lib'
  t.libs.push 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
  t.warning = false # set to true for Ruby warnings (ruby -w)
end

YARD::Rake::YardocTask.new(:yard) do |t|
  t.files = [
    'lib/**/*.rb',
    '-',
    'docs/api.md',
    'docs/getting_started.md',
    'docs/views.md',
  ]
end

Inch::Rake::Suggest.new(:inch) do |suggest|
  suggest.args << '--pedantic'
  suggest.args << '--all'
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']
  task.formatters = ['progress']
  task.fail_on_error = false
end

task default: :test
