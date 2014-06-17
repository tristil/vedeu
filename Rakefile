require "bundler/gem_tasks"
require "rake/testtask"
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = "features --format progress"
end

Rake::TestTask.new(:minitest) do |t|
  t.libs << 'lib/vedeu'
  t.test_files = FileList["test/lib/vedeu/*_test.rb",
                          "test/lib/vedeu/**/*_test.rb"]
  t.verbose = false
end

task default: :minitest

Rake::Task['minitest'].execute

Rake::Task['cucumber'].execute
