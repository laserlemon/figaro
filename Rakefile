#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"
require "appraisal"

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber)

task :default => [:spec, :cucumber]
