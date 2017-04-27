class MainController < ApplicationController
	# before_action :authenticate_admin!, except: [:index]

	def index
		render plain: 'Server is up and running'
	end

	# Godview data
	def entities
		@admins = Rails.cache.fetch("entities_admins", :expires_in => 5.minute) do
			Admin.includes(:applications)
		end
		# @admins = Admin.includes(:applications)
		# @applications = Application.all
		@applications = Rails.cache.fetch("entities_applications", :expires_in => 5.minute) do
			Application.all
		end
		# @active_apps = Application.installed.all
		@active_apps = Rails.cache.fetch("entities_active_applications", :expires_in => 5.minute) do
			Application.installed.all
		end
		# @fb_pages = FbPage.all
		@fb_pages = Rails.cache.fetch("entities_fb_pages", :expires_in => 5.minute) do
			FbPage.all
		end
		# @fb_apps = FbApplication.all
		@fb_apps = Rails.cache.fetch("entities_fb_apps", :expires_in => 5.minute) do
			FbApplication.all
		end
		# @plans = SubscriptionPlan.all
		@plans = Rails.cache.fetch("entities_plans", :expires_in => 5.minute) do
			SubscriptionPlan.all
		end
		@summarydata = [
			{
				"title": "Total Apps",
				"value": @applications.length
			},
			{
				"title": "Active Apps",
				"value": @active_apps.length
			},
			{
				"title": "Total Admins",
				"value": @admins.length
			},
			{
				"title": "Total Orders",
				"value": 0
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
