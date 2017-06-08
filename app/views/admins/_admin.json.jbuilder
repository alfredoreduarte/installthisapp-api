json.extract! admin, :id, :name, :email, :fb_profile, :fb_pages, :created_at
json.applications do 
	json.array! admin.applications, partial: 'applications/godview', as: :application
end