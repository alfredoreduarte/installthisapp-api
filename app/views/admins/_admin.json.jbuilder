json.extract! admin, :id, :name, :email, :fb_profile, :fb_pages, :created_at
json.applications do 
	json.array! admin.applications, partial: 'applications/godview', as: :application
end
json.fb_leadforms do 
	json.array! admin.fb_leadforms, partial: 'fb_leadforms/fb_leadform', as: :fb_leadform
end