json.extract! application, :id, :checksum, :title, :application_type, :admin_id, :status, :created_at
if application.fb_application
	json.fb_application do 
		json.partial! application.fb_application, partial: 'fb_applications/fb_application', as: :fb_application
	end
end
if application.fb_page
	json.fb_page do 
		json.partial! application.fb_page, partial: 'fb_pages/fb_page', as: :fb_page
	end
end