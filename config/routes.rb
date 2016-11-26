require 'resque/server'
Rails.application.routes.draw do
	mount Payola::Engine => '/payola', as: :payola
	resources :customers
		# get 'customers/card', to: 'customers#get_card'
	# resources :subscriptions
		# post 'subscriptions/update', to: 'subscriptions#update'
		# delete 'subscriptions/delete', to: 'subscriptions#delete'
	root 'main#index'
	mount Resque::Server => '/resque'
	get 'fb_profiles/fetch_fb_pages.json', to: 'fb_profiles#fetch_fb_pages'
	resources :plans
	resources :fb_users, path: 'users'
	resources :applications
	resources :fb_applications
	resources :fb_pages
	resources :fb_profiles
	mount_devise_token_auth_for 'Admin', at: 'auth'
	get 'admins/entities', to: 'admins#entities'
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
	match '/jsonmock', to: "admins#jsonmock", via: [:get]

	# 
	# FB Page realtime subscriptions
	# 
	match '/fb_webhook_top_fans', to: "fb_webhook#top_fans", via: [:get, :post]

end
