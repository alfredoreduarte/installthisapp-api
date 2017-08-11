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

json.fb_leadforms do 
	json.array! @admin.fb_leadforms, partial: 'fb_leadforms/fb_leadform', as: :fb_leadform
end

json.fb_lead_destinations do 
	json.array! @admin.fb_lead_destinations, partial: 'fb_lead_destinations/fb_lead_destination', as: :fb_lead_destination
end