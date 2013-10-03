require "sinatra"
require "compass"
require "susy"
require "pry"
require 'compass-h5bp'

Compass.add_project_configuration 'config.rb'

Compass.sass_engine_options[:load_paths].each do |path|
  Sass.load_paths << path
end

defaults = '@import "themes/_defaults.scss"'
base = '@import "base.scss"'

get '/' do
  "Hellos"
end


post '/compile-sass' do
  sass = params[:sass]

  begin
    # template = File.read("template.css.scss")
    template = defaults + params[:sass] + base
    sass_engine = Sass::Engine.new(template, :syntax => :scss)
    sass_engine.render
  rescue Sass::SyntaxError => e
    status 200
    e.to_s
  end if sass
end

# render :scss, template, options, locals
