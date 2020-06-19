# frozen_string_literal: true

require 'scss_lint/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

SCSSLint::RakeTask.new
task default: %i[scss_lint rubocop]
