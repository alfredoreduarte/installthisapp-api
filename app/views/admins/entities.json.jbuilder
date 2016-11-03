# json.products do
# end

# json.admin do
json.extract! @admin, :id, :name, :email, :fb_profile#, :customer #, :subscription
	# applications
# end
# json.subscription @admin.has_subscription
# json.subscription @admin.subscriptions.last.as_json(include: [:plan])
json.applications do
	json.array! @admin.applications, partial: 'applications/application', as: :application
end
json.pages do
	json.array! @admin.fb_pages, partial: 'fb_pages/fb_page', as: :fb_page
end
# json.plans do
	# json.array! @plans, partial: 'plans/plan', as: :plan
# end
# json.url herb_url(herb, format: :json)