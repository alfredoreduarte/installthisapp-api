json.extract! application, :id, :checksum, :title, :application_type, :admin_id, :status, :created_at
if json.fb_application
	json.fb_application do 
		json.partial! application.fb_application, partial: 'fb_applications/fb_application', as: :fb_application
	end
end
# json.fb_page