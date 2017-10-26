require 'resque/server'

# Protecting the Resque control panel
if ENV['RESQUE_ADMIN_PASSWORD']
	Resque::Server.use Rack::Auth::Basic do |username, password|
		password == ENV['RESQUE_ADMIN_PASSWORD']
	end
end

Rails.application.routes.draw do
	mount Payola::Engine => '/payola', as: :payola
	root 'main#index'
	mount Resque::Server => '/resque'
	mount_devise_token_auth_for 'Admin', at: 'auth'
	get 'admins/entities', to: 'admins#entities'
	post 'admins/resend_email_confirmation.json', to: 'admins#resend_email_confirmation'
	get 'fb_profiles/fetch_fb_pages.json', to: 'fb_profiles#fetch_fb_pages'
	get 'fb_pages/:identifier/fetch_leadgen_forms.json', to: 'fb_pages#fetch_leadgen_forms'
	resources :two_checkout_notifications
	resources :admins
	resources :fb_users, path: 'users'
	resources :applications
	resources :fb_applications
	resources :fb_pages
	resources :fb_profiles
	resources :fb_lead_destinations
	resources :fb_leadforms
	post 'fb_leadforms/:id/test.json', to: 'fb_leadforms#test'
	get 'fb_leadforms/:id/get_existing_test_lead.json', to: 'fb_leadforms#get_existing_test_lead'
	get 'fb_leadforms/:lead_id/poll_test_arrival.json', to: 'fb_leadforms#poll_test_arrival'
	get 'fb_leadforms/:lead_id/poll_test_notification_delivery.json', to: 'fb_leadforms#poll_test_notification_delivery'
	# resources :fb_leadforms do 
		# post 'test', to: 'test'
	# end
	resources :app_integrations
	match '/applications/:checksum/:action.json', to: "applications#:action", via: [:get, :post, :delete, :put, :patch]
	match '/applications/:checksum/:action/:id.json', to: "applications#:action", via: [:get, :post, :delete, :put, :patch]

	# 
	# GODVIEW
	# 
	match '/entities(.:format)', to: "main#entities", via: [:get]
	match '/apps(.:format)', to: "main#apps", via: [:get]
	match '/create_subscription_plan', to: "main#create_subscription_plan", via: [:post]
	match '/remove_subscription_plan/:id', to: "main#remove_subscription_plan", via: [:delete]
	match '/subscription_plans', to: "main#subscription_plans", via: [:get]

	# 
	# FB Page realtime subscriptions
	# 
	match '/fb_webhooks', to: "fb_webhooks#receive", via: [:get, :post]
	match '/fb_webhooks/verify_page_subscription', to: "fb_webhooks#verify_page_subscription", via: [:get, :post]

	# 
	# CANVAS
	# 
	match '/fb_tab_auth.json', to: "canvas#fb_tab_auth", via: [:post]
	match '/standalone_auth.json', to: "canvas#standalone_auth", via: [:post]
	match '/:checksum/:action.json', to: "canvas#:action", via: [:get, :post]

end
