class MainController < ApplicationController
	# before_action :authenticate_admin!, except: [:index]
	# before_action :authenticate_admin!
	def index
		render plain: 'Server is up and running'
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
				stripeId: plan.stripe_id,
				name: plan.name,
				amount: plan.amount,
				interval: plan.interval,
				trialPeriodDays: plan.trial_period_days,
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
