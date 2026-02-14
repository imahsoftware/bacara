ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup'

ENV['NLS_LANG'] ||= 'AMERICAN_AMERICA.UTF8'
