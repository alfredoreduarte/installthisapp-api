json.summary do
	json.array! @summary do |summary|
		json.title summary[:title]
		json.value summary[:value]
	end
end

json.users do
	json.array! @admins, partial: 'admins/admin', as: :admin
end

json.fb_applications do
	json.array! @fb_apps, :id, :name, :app_id, :secret_key, :application_type, :canvas_id, :namespace
end

json.fb_leadforms do
	json.array! @fb_leadforms, :id, :fb_page_identifier, :fb_form_id, :admin_id, :created_at
end

json.fb_lead_destinations do
	json.array! @fb_lead_destinations, :id, :destination_type, :status, :settings, :admin_id, :fb_leadform_id, :created_at
end

json.plans do
	json.array! @plans, :id, :name, :stripe_id, :amount, :interval, :trial_period_days
end