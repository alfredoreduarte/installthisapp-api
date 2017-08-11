json.extract! admin, :id, :name, :email, :fb_profile, :fb_pages, :created_at
json.applications do 
	json.array! admin.applications, partial: 'applications/godview', as: :application
end
json.fb_leadforms do 
	json.array! admin.fb_leadforms, partial: 'fb_leadforms/fb_leadform', as: :fb_leadform
end
json.fb_lead_destinations do 
	json.array! admin.fb_lead_destinations, partial: 'fb_lead_destinations/fb_lead_destination', as: :fb_lead_destination
end