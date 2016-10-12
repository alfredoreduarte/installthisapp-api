Rails.application.routes.draw do
	resources :fb_users
	resources :applications
	resources :fb_applications
	resources :fb_pages
	resources :fb_profiles
	mount_devise_token_auth_for 'Admin', at: 'auth'
	root 'main#index'
	# resources :users
	# resources :fb_applications
	# resources :applications
	# resources :admins do
		# get 'entities', to: 'admins#entities'
		# collection do
			# resources :fb_pages do
				# collection do
					# get 'fetch'
				# end
			# end
		# end
	# end
	get 'admins/entities', to: 'admins#entities'
	match '/applications/:checksum/:action.json', to: "applications#:action", via: [:get, :post]

	# 
	# CANVAS
	# 
	match '/auth.json', to: "canvas#auth", via: [:post]
	match '/standalone_auth.json', to: "canvas#standalone_auth", via: [:post]
	match '/:checksum/:action.json', to: "canvas#:action", via: [:get, :post]

	# 
	# GODVIEW
	# 
	match '/jsonmock', to: "admins#jsonmock", via: [:get]

	# 
	# FB Page realtime subscriptions
	# 
	match '/top_fans_stats', to: "fb_page_subscription#top_fans_stats", via: [:get]
	match '/likes_by_page', to: "fb_page_subscription#likes_by_page", via: [:get]
	match '/subscription', to: "fb_page_subscription#subscription", via: [:get, :post]
end
