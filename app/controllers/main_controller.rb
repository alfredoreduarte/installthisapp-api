class MainController < ApplicationController
	# before_action :authenticate_admin!, except: [:index]

	def timeline_contest
		require 'fb_api'
		a_token = "EAACEdEose0cBABZBNdqFj3nq0kF34h8gVdx4Iz478rsNch2tE1acxOYZCbkQqX77hetp67ZBpSrDgsZCGmEbjyZAMo7AbVa4ahGHL4LoCIgl0qJDRrAKBkdmMH53Rjk3WEeXSU65PCQQYLZBweSYss97ZBhYZA8KtKbpXlyviro5t0l017XZArZCUYLGUrHp9od9MZD"
		if params[:url]
			result = FbApi::get_page_id_from_post_url(a_token, params[:url])
			page_id = result["id"]
			reactions_result = FbApi::get_reactions_for_post(a_token, page_id, params[:url])
			logger.info(reactions_result)
			# logger.info('es?')
			# logger.info(!reactions_result["paging"]["next"].nil?)
			# logger.info(reactions_result["paging"]["next"].nil?)
			# logger.info(reactions_result["paging"]["next"].blank?)
			if !reactions_result["paging"]["next"].nil?
				extended_results = FbApi::generic_request(reactions_result["paging"]["next"])
				logger.info('extended_results')
				logger.info(extended_results)
				while !extended_results["paging"]["next"].nil?
					extended_results = FbApi::generic_request(extended_results["paging"]["next"])
					logger.info('extended_results')
					logger.info(extended_results)
				end
			end
			# logger.info(result)
			# logger.info(result["id"])
		end
		response = {"status": "ok"}
		respond_to do |format|
			format.json { render json: response }
		end
	end

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
