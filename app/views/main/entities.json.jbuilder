json.summary do
	json.array! @summary do |summary|
		json.title summary[:title]
		json.value summary[:value]
	end
end

json.users do
	# json.array! @admins, :id, :name, :email, :fb_profile, :fb_pages, :created_at, :applications
	json.array! @admins, partial: 'admins/admin', as: :admin
end

# json.applications do
# 	json.array! @applications, :id, :checksum, :title, :application_type, :status, :fb_page, :fb_application
# end

# json.fb_pages do
# 	json.array! @fb_pages, :id, :identifier, :name
# end

json.fb_applications do
	json.array! @fb_apps, :id, :name, :app_id, :secret_key, :application_type, :canvas_id, :namespace
end

json.plans do
	json.array! @plans, :id, :name, :stripe_id, :amount, :interval, :trial_period_days
end