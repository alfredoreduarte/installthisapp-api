class MainController < ApplicationController
	# before_action :authenticate_admin!, except: [:index]

	def index
		render plain: 'Server is up and running'
	end

	# Godview data
	def entities
		@admins = Rails.cache.fetch("entities_admins", :expires_in => 5.minute) do
			# Admin.includes(applications: [:fb_application], :fb_pages)
			Admin.includes( { applications: [ :fb_application, :fb_page ] }, :fb_pages)
			# Admin.includes(applications: [:fb_application])
		end
		# logger.info(@admins.first.applications.installed.first.as_json)
		@applications = Rails.cache.fetch("entities_applications", :expires_in => 5.minute) do
			Application.all
		end
		@fb_pages = Rails.cache.fetch("entities_fb_pages", :expires_in => 5.minute) do
			FbPage.all
		end
		@fb_apps = Rails.cache.fetch("entities_fb_apps", :expires_in => 5.minute) do
			FbApplication.all
		end
		@fb_leadforms = Rails.cache.fetch("entities_fb_leadforms", :expires_in => 5.minute) do
			FbLeadform.all
		end
		@fb_lead_destinations = Rails.cache.fetch("entities_fb_lead_destinations", :expires_in => 5.minute) do
			FbLeadDestination.all
		end
		@plans = Rails.cache.fetch("entities_plans", :expires_in => 5.minute) do
			SubscriptionPlan.all
		end
		@summary = [
			{
				"title": "Total Apps",
				"value": @applications.length
			},
			{
				"title": "Active Apps",
				"value": @applications.installed.length
			},
			{
				"title": "Total Admins",
				"value": @admins.length
			},
			{
				"title": "Active Subscriptions",
				"value": Payola::Subscription.where(state: "active").length
			}
		]
	end

	def subscription_plans
		response = SubscriptionPlan.all.as_json
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def create_subscription_plan
		hash = params.deep_symbolize_keys
		plan = SubscriptionPlan.create(
			stripe_id: hash[:stripeId], 
			name: hash[:name], 
			amount: hash[:amount], 
			interval: hash[:interval], 
			trial_period_days: hash[:trialPeriodDays]
		)
		if plan.valid?
			response = {
				id: plan.id,
				stripe_id: plan.stripe_id,
				name: plan.name,
				amount: plan.amount,
				interval: plan.interval,
				trial_period_days: plan.trial_period_days,
			}
		else
			response = {
				error: plan.errors.full_messages,
			}
		end
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def remove_subscription_plan
		plan = SubscriptionPlan.find(params[:id])
		if plan.destroy
			response = {
				status: 'ok',
			}
		else
			response = {
				status: plan.errors.full_messages,
			}
		end
		respond_to do |format|
			format.json { render json: response }
		end
	end
end
