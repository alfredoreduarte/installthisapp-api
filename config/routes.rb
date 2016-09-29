Rails.application.routes.draw do
	root 'main#index'
	resources :users
	resources :fb_applications
	resources :applications
	resources :admin_users do
		collection do
			resources :fb_pages do
				collection do
					get 'fetch'
				end
			end
		end
	end
	match '/applications/:checksum/:action.json', to: "applications#:action", via: [:get, :post]
	# scope '/trivia' do

	# end

	# 
	# CANVAS
	# 
	match '/auth.json', to: "canvas#auth", via: [:post]
	match '/standalone_auth.json', to: "canvas#standalone_auth", via: [:post]
	match '/:checksum/:action.json', to: "canvas#:action", via: [:get, :post]

	# 
	# GODVIEW
	# 
	match '/jsonmock', to: "admin_users#jsonmock", via: [:get]

	# 
	# FB Page realtime subscriptions
	# 
	match '/top_fans_stats', to: "fb_page_subscription#top_fans_stats", via: [:get]
	match '/likes_by_page', to: "fb_page_subscription#likes_by_page", via: [:get]
	match '/subscription', to: "fb_page_subscription#subscription", via: [:get, :post]
end
