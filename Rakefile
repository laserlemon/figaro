require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber)

task :default => [:spec, :cucumber]

if ENV["COVERAGE"]
  Rake::Task[:default].enhance do
    require "simplecov"
    require "coveralls"

    Coveralls::SimpleCov::Formatter.new.format(SimpleCov.result)
  end
end
