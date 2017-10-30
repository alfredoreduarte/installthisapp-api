# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
	allow do
		origins "#{ENV['AUTHORIZED_CLIENT_APP_URL_1']}", "#{ENV['AUTHORIZED_CLIENT_APP_URL_2']}", "#{ENV['AUTHORIZED_CLIENT_APP_URL_3']}", "#{ENV['AUTHORIZED_CLIENT_APP_URL_4']}", "localhost.ssl:4000"
		resource '*',
			headers: :any,
			expose: ['access-token', 'client', 'uid', 'token-type'],
			methods: [:get, :post, :put, :patch, :delete, :options, :head]
	end
end
