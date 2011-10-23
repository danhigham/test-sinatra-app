require 'bundler/setup'
require 'fileutils'
require 'sinatra/base'

# Set environment and run Bundler require
ENV['RACK_ENV'] = 'production' if ENV['RACK_ENV'].nil?

Bundler.require(:default, ENV['RACK_ENV']) if defined?(Bundler)

require './example_app'

run Rack::Cascade.new [ExampleApp]

