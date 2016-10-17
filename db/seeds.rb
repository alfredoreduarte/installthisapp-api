# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env == "production"
	FbApplication.create(
		name: "Trivia", 
		app_id: "1524466891193222", 
		secret_key: "c96d0e9a4af8cfaecbc712d8668d6a9f", 
		application_type: "trivia", 
		canvas_id: "app1", 
		namespace: "itapp_i",
	)
	FbApplication.create(
		name: "Top Fans", 
		app_id: "1765290210276195", 
		secret_key: "e65f9029cc9cb54b585a4e316a2860b5", 
		application_type: "top_fans", 
		canvas_id: "app2", 
		namespace: "itapp_ii",
	)
	FbApplication.create(
		name: "Photo Contest", 
		app_id: "1194295113924028",
		secret_key: "083127ccbb7aa6571800f65651b226bb", 
		application_type: "photo_contest", 
		canvas_id: "app3", 
		namespace: "itapp_iii",
	)
elsif Rails.env == "stage"
	FbApplication.create(
		name: "Trivia", 
		app_id: "966872033362481", 
		secret_key: "5bb5767812f1c7ff8ffaf065d2c3f54b", 
		application_type: "trivia", 
		canvas_id: "app1", 
		namespace: "ita_stage_i",
	)
	FbApplication.create(
		name: "Top Fans", 
		app_id: "1064994573589524", 
		secret_key: "1658d0a2c742ba7ed94f1f55741f89a5", 
		application_type: "top_fans", 
		canvas_id: "app2", 
		namespace: "ita_stage_ii",
	)
	FbApplication.create(
		name: "Photo Contest", 
		app_id: "568683929989967", 
		secret_key: "34d52192a1eba9b02c6070f423f1da16", 
		application_type: "photo_contest", 
		canvas_id: "app3", 
		namespace: "ita_stage_iii",
	)
elsif Rails.env == "development"
	FbApplication.create(
		name: "Trivia", 
		app_id: "1525778314395413",
		secret_key: "8f2a3a93a7d3d41ee3ddb96e1062c9dd", 
		application_type: "trivia", 
		canvas_id: "app1", 
		namespace: "ita_dev_i_i",
	)
	FbApplication.create(
		name: "Top Fans", 
		app_id: "1765290880276128", 
		secret_key: "c451a330be8d758a3aa5ab107c794fec", 
		application_type: "top_fans", 
		canvas_id: "app2", 
		namespace: "ita_dev_i_ii",
	)
	FbApplication.create(
		name: "Photo Contest", 
		app_id: "1194297433923796",
		secret_key: "4f545ea335fb60992e1a05cbd5a80fee", 
		application_type: "photo_contest", 
		canvas_id: "app3", 
		namespace: "ita_dev_i_iii",
	)
end