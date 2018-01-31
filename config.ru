require 'rubygems'
require 'bundler'
Bundler.require

require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

require File.expand_path('app.rb', File.dirname(__FILE__))

run Sinatra::Application
