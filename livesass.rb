require "sinatra"
require "compass"
require "susy"
require "pry"
require 'compass-h5bp'

Compass.add_project_configuration 'config.rb'

Compass.sass_engine_options[:load_paths].each do |path|
  Sass.load_paths << path
end


default = '@import "themes/_default.scss";'
base = '@import "base";'

get '/' do
  "Hellos"
end

post '/compile-sass' do
  sass = params[:sass]

  begin
    template = default + "body{ color: red;}" + base
    sass_engine = Sass::Engine.new(template, :syntax => :scss)
    sass_engine.render
  rescue Sass::SyntaxError => e
    status 200
    e.to_s
  end if sass
end

# render :scss, template, options, locals

