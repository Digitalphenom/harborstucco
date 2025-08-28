
require 'erubi'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack-livereload'

configure do
  use Rack::LiveReload
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
  set :public_folder, File
    .expand_path('../harbor_stucco/public', __dir__)
  set :views, File.expand_path('../harbor_stucco/views', __dir__)
  #set :erb, escape_html: true
end

# ‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧

get '/' do
  erb :"home.html", layout: :"layout.html"
end