json.extract! @admin, :id, :name, :email, :fb_profile, :created_at, :confirmed_at

json.subscription @admin.subscription

json.applications do
	json.array! @admin.applications, partial: 'applications/application', as: :application
end

json.pages do
	json.array! @admin.fb_pages, partial: 'fb_pages/fb_page', as: :fb_page
end

json.plans do
	json.array! @plans, partial: 'subscription_plans/plan', as: :plan
end