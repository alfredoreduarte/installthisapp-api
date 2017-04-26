require 'resque/server'
Rails.application.routes.draw do
	mount Payola::Engine => '/payola', as: :payola
	root 'main#index'
	mount Resque::Server => '/resque'
	mount_devise_token_auth_for 'Admin', at: 'auth'
	get 'admins/entities', to: 'admins#entities'
	get 'fb_profiles/fetch_fb_pages.json', to: 'fb_profiles#fetch_fb_pages'
	resources :admins
	resources :fb_users, path: 'users'
	resources :applications
	resources :fb_applications
	resources :fb_pages
	resources :fb_profiles
	match '/applications/:checksum/:action.json', to: "applications#:action", via: [:get, :post, :delete, :put, :patch]

	# 
	# CANVAS
	# 
	match '/canvasauth.json', to: "canvas#auth", via: [:post]
	match '/standalone_auth.json', to: "canvas#standalone_auth", via: [:post]
	match '/:checksum/:action.json', to: "canvas#:action", via: [:get, :post]

	# 
	# GODVIEW
	# 
	match '/entities(.:format)', to: "main#entities", via: [:get]
	match '/create_subscription_plan', to: "main#create_subscription_plan", via: [:post]
	match '/remove_subscription_plan/:id', to: "main#remove_subscription_plan", via: [:delete]
	match '/subscription_plans', to: "main#subscription_plans", via: [:get]

	# 
	# FB Page realtime subscriptions
	# 
	match '/fb_webhook_top_fans', to: "fb_webhook#top_fans", via: [:get, :post]

end
