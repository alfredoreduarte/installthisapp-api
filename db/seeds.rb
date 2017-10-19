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
		app_id: "1652455931439619",
		secret_key: "5ff8a29a0096408d1e4cf85b078cff06", 
		application_type: "trivia", 
		canvas_id: "app1", 
		namespace: "ita_dev_i_i",
	)
	FbApplication.create(
		name: "Top Fans", 
		app_id: "1941701466067415", 
		secret_key: "2271c50848c08e11048f4862a695c23f", 
		application_type: "top_fans", 
		canvas_id: "app2", 
		namespace: "ita_dev_i_ii",
	)
	FbApplication.create(
		name: "Photo Contest", 
		app_id: "1883096718679148",
		secret_key: "c5386088eb565f21a07963c067804b3d", 
		application_type: "photo_contest", 
		canvas_id: "app3", 
		namespace: "ita_dev_i_iii",
	)
	FbApplication.create(
		name: "Memory Match", 
		app_id: "712988888886640",
		secret_key: "872edc3ad4f26eceb72a984b8e0e5123", 
		application_type: "memory_match", 
		canvas_id: "app4", 
		namespace: "ita_dev_i_iv",
	)
	FbApplication.create(
		name: "Catalog", 
		app_id: "1853024735025880",
		secret_key: "0384545b217d957ff10f8d6c757eccd6", 
		application_type: "catalog", 
		canvas_id: "app5", 
		namespace: "ita_dev_i_v",
	)
	FbApplication.create(
		name: "Form", 
		app_id: "120581995273318",
		secret_key: "4d2e490ea3b2264bef02898221e66c99", 
		application_type: "form", 
		canvas_id: "app6", 
		namespace: "ita_dev_i_vi",
	)
	FbApplication.create(
		name: "Fan Gate", 
		app_id: "361364880986137",
		secret_key: "24bc09fd9c99db5df83685b294c2635d", 
		application_type: "fan_gate", 
		canvas_id: "app7", 
		namespace: "ita_dev_i_vii",
	)
	FbApplication.create(
		name: "Coupons", 
		app_id: "177335809496005",
		secret_key: "57695fa2d8cab89ece5585091e9320ca", 
		application_type: "coupons", 
		canvas_id: "app8", 
		namespace: "ita_dev_i_viii",
	)
	# Basic Plan
	SubscriptionPlan.create(
		amount: 2900,
		interval: 'month',
		stripe_id: 'basic',
		name: 'Basic',
		trial_period_days: 7,
	)
	# Demo plan
	SubscriptionPlan.create(
		amount: 0000,
		interval: 'month',
		stripe_id: 'demo',
		name: 'Demo',
		trial_period_days: 7,
	)
end