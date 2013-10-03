require "sinatra"
require 'sinatra/cross_origin'
require "compass"
require "susy"
require "pry"
require 'compass-h5bp'

configure do
  enable :cross_origin
end

set :public_folder, File.dirname(__FILE__) + '/static'

Compass.add_project_configuration 'config.rb'

Compass.sass_engine_options[:load_paths].each do |path|
  Sass.load_paths << path
end


default = '@import "themes/_default.scss";'
base = '@import "base";'

get '/' do
  'Hello'
end

post '/compile-sass' do
  cross_origin
  sass = params[:sass]

  begin
    template = default + params[:sass] + base
    sass_engine = Sass::Engine.new(template, :syntax => :scss)
    save_file(sass_engine.render)
  rescue Sass::SyntaxError => e
    status 200
    e.to_s
  end if sass
end

def save_file(contents)
  tempdir = "./tmp"

  output = Tempfile.open("css", tempdir)
  output.write(contents)
  output.close
  digest = Digest::MD5.file(output).hexdigest
  filename = "css/#{digest}.css"
  File.rename(output, "static/#{filename}")
  output.unlink
  "//#{request.host}/#{filename}"
end

# render :scss, template, options, locals

