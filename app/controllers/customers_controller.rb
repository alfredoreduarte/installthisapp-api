class CustomersController < ApplicationController
	before_action :authenticate_admin!

	def create
		plan = Plan.find_by(slug: params["plan"])
		customer = Customer.new(admin: current_admin)
		customer.plan = plan
		customer.token = params[:id]
		if customer.save
			render json: {
				success: true,
				message: "Account created. Please wait"
			}
		else
			render json: {
				success: false,
				message: customer.errors.full_messages
			}
		end
	end

	def update
		
	end

	def get_card
		card = current_admin.customer.get_card
		render json: {
			brand: card.brand,
			last4: card.last4
		}
	end

end
