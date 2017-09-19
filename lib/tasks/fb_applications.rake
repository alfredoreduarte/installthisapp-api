namespace :fb_applications do
	desc "TODO"
	task seed_staging: :environment do
		FbApplication.create!([
			{
				name: "Trivia", 
				app_id: "966872033362481",
				secret_key: "5bb5767812f1c7ff8ffaf065d2c3f54b", 
				application_type: "trivia", 
				canvas_id: "app1", 
				namespace: "ita_staging_i",
			},
			{
				name: "Top Fans", 
				app_id: "1064994573589524",
				secret_key: "1658d0a2c742ba7ed94f1f55741f89a5", 
				application_type: "top_fans", 
				canvas_id: "app2", 
				namespace: "ita_staging_ii",
			},
			{
				name: "Photo Contest", 
				app_id: "199928490498786",
				secret_key: "1ed7900133c7307ad0bfce392f85b8f0", 
				application_type: "photo_contest", 
				canvas_id: "app3", 
				namespace: "ita_staging_iii",
			},
			{
				name: "Memory Match", 
				app_id: "1280529118669559",
				secret_key: "d677cc5ae503bb2146aa128e3705c25c", 
				application_type: "memory_match", 
				canvas_id: "app4", 
				namespace: "ita_staging_iv",
			},
			{
				name: "Catalog", 
				app_id: "1613262845358655",
				secret_key: "9d80bb0b2d353b8eac30e1903203dcf0", 
				application_type: "catalog", 
				canvas_id: "app5", 
				namespace: "ita_staging_v",
			},
		])
	end

	p  "Created #{FbApplication.count} Fb Applications"
end