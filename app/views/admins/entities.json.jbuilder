# json.products do
# end

# json.admin do
json.extract! @admin, :id, :name, :email, :fb_profile
	# applications
# end
json.applications do
	json.array! @admin.applications, partial: 'applications/application', as: :application
end
json.pages do
	json.array! @admin.fb_pages, partial: 'fb_pages/fb_page', as: :fb_page
end
# json.url herb_url(herb, format: :json)