# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop-ci'
require 'generative/rake_task'

RSpec::Core::RakeTask.new(:spec)
Generative::RakeTask.new

task default: :spec
