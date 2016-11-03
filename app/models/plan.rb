class Plan < ApplicationRecord
	enum interval: { day: 0, month: 1, week: 2, year: 3 }
	has_many :subscriptions
	before_create :create_stripe_plan
	before_update :update_stripe_plan
	before_destroy :destroy_stripe_plan

	private

	def update_stripe_plan
		require "stripe"
		p = Stripe::Plan.retrieve(self.id)
		p.name = self.name
		p.save
	end

	def create_stripe_plan
		require "stripe"
		if self.price.to_i > 0
			customer = Stripe::Plan.create(
				:amount => self.price.to_i * 100,
				:interval => self.interval,
				:name => self.name,
				:currency => "usd",
				:id => self.slug,
			)
			logger.info('response!')
			logger.info(customer.inspect)
		else
			logger.info('Price was zero, stripe plan not created')
		end
	end

	def destroy_stripe_plan
		require "stripe"
		plan = Stripe::Plan.retrieve(self.slug)
		plan.delete
		logger.info('response!')
		logger.info(plan.inspect)
	end

end
