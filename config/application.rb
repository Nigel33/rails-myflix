require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end

    config.autoload_paths << "#{Rails.root}/lib"

    Raven.configure do |config|
      config.dsn = 'https://6e5975c5c7e0487da11f07df9a8488ad:81935755549c48989645c6be271bf683@sentry.io/1466214'
    end
  end
end

