
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/content_for'
require 'rack-livereload'
require 'yaml'

require_relative 'app/helpers/view_helpers.rb'
# ‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧‧

class HarborStucco < Sinatra::Base
  set :session_secret, SecureRandom.hex(32)
  set :public_folder, File.expand_path('../harbor_stucco/public', __dir__)
  set :views, File.expand_path('../harbor_stucco/views', __dir__)
  set :erb, escape_html: true
  helpers Sinatra::ContentFor
  helpers ViewHelpers
  enable :sessions

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader

    also_reload "app/helpers/view_helpers.rb"
    also_reload "app/helpers/content_helpers.rb"
    also_reload "harbor_stucco.rb"

    use Rack::LiveReload,
      min_delay: 500,
      max_delay: 10_000,
      no_swf: true
  end

  before do 
    @home_page = YAML.load_file('data/home.yaml')
    @alt_tags = YAML.load_file('data/alt_tags.yaml')
    @layout = YAML.load_file('data/layout.yaml')
    @restucco = YAML.load_file('data/restucco.yaml')
  end

  get '/' do
    erb :"home/home.html", layout: :"layout.html"
  end

  get '/estimate' do
    erb :"estimate.html", layout: :"layout.html"
  end
  
  get '/stuccorepair' do
    erb :"stuccorepair.html", layout: :"layout.html"
  end

  get '/re-stucco' do
    @headline = select_restucco_content('MAIN', 'headline')
    @intro_headline = select_restucco_content('INTRO', 'headline')
    @intro_content = select_restucco_content('INTRO', 'content')
    @intro_link = select_restucco_content('INTRO', 'link')
    @pricing_headline = select_restucco_content('PRICING', 'headline')
    @pricing_content = select_restucco_content('PRICING', 'content')
    @qna_questions = select_restucco_content('QNA', 'questions')
    @qna_headline = select_restucco_content('QNA', 'headline')
    
    erb :"re-stucco.html", layout: :"layout.html"
  end

  get %r{/(.+)\.html} do
    path = params['captures'].first
    redirect "/#{path}", 301
  end
end
