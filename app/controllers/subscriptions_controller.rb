class SubscriptionsController < ApplicationController
	before_action :authenticate_admin!

	def create
		plan = Plan.find_by(slug: params["plan"])
		subscription = Subscription.new( customer: current_admin.customer )
		subscription.plan = plan
		subscription.token = params[:id]
		if subscription.save
			render json: {
				success: true,
				message: "Account created. Please wait"
			}
		else
			render json: {
				success: false,
				message: subscription.errors.full_messages
			}
		end
	end

	def update
		subscription = current_admin.subscription
		plan = Plan.find_by(slug: params["plan"])
		subscription.plan = plan
		if subscription.save
			render json: {
				success: true,
				message: "Account created. Please wait"
			}
		else
			render json: {
				success: false,
				message: subscription.errors.full_messages
			}
		end
	end

	def destroy
		if current_admin.subscription.destroy
			# current_admin.subscription.cancel_stripe_subscription
			render json: {
				success: true,
			}
		else
			render json: {
				success: false,
				message: current_admin.subscription.errors.full_messages
			}
		end
	end
end
