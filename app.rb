require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
get '/' do
  "Hello world!"
end