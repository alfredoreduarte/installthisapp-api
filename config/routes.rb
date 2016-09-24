Rails.application.routes.draw do
  resources :users
  resources :fb_pages
  resources :fb_applications
  resources :applications
  resources :admin_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
