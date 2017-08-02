# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env == "development"
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
	FbApplication.create(
		name: "Memory Match", 
		app_id: "1303618956340973",
		secret_key: "a3a58110eeb29f8f423f48dfb2193f4f", 
		application_type: "memory_match", 
		canvas_id: "app4", 
		namespace: "ita_dev_i_iv",
	)
	FbApplication.create(
		name: "Catalog", 
		app_id: "639649409573258",
		secret_key: "560b4be68a7f53ea091ebee7b151b07d", 
		application_type: "catalog", 
		canvas_id: "app5", 
		namespace: "ita_dev_i_v",
	)
	SubscriptionPlan.create(
		amount: 2900,
		interval: 'month',
		stripe_id: 'basic',
		name: 'Basic',
		trial_period_days: 7,
	)
end