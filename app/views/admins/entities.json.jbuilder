# json.products do
# end

# json.admin do
json.extract! @admin, :id, :name, :email
	# applications
# end
json.applications do
	json.array! @admin.applications, partial: 'applications/application', as: :application
end
# json.url herb_url(herb, format: :json)