require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ItaApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join('modules').to_s
    # config.force_ssl = true

    # Using GZip compression on all responses
    config.middleware.use Rack::Deflater

    config.cache_store = :memory_store, { size: 64.megabytes }

    # 
    # This sets active_record the default generator again, after installing mongoid
    # http://stackoverflow.com/questions/6372626/using-active-record-generators-after-mongoid-installation
    # 
    config.generators do |g| 
  		g.orm :active_record 
  	end
  end
  require Rails.root.join('lib', 'modules.rb').to_s

  Modules::Base.initialize!
end
