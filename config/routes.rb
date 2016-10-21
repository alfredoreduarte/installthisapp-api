require 'resque/server'
Rails.application.routes.draw do
	root 'main#index'
	# mount Resque::Server.new, :at => "/resque"
	mount Resque::Server => '/resque'
	# resources :fb_users
	get 'fb_profiles/fetch_fb_pages.json', to: 'fb_profiles#fetch_fb_pages'
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
	# match '/top_fans_stats', to: "fb_page_subscription#top_fans_stats", via: [:get]
	# match '/likes_by_page', to: "fb_page_subscription#likes_by_page", via: [:get]
	match '/subscription', to: "fb_page_subscription#subscription", via: [:get, :post]
end
