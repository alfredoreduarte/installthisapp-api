class Customer < ApplicationRecord
	require "stripe"
	belongs_to :admin
	has_one :subscription
	before_create :create_stripe_customer
	before_create :create_customer_subscription
	# before_create :create_stripe_customer_with_subscription
	# after_create :create_customer_subscription
	before_destroy :destroy_stripe_customer

	attr_accessor :token
	attr_accessor :plan

	def get_card
		stripe_customer = Stripe::Customer.retrieve(self.external_id)
		card_id = stripe_customer.sources.total_count == 1 ? stripe_customer.sources.data.first.id : "fake_card"
		stripe_card = stripe_customer.sources.retrieve(card_id)
		return stripe_card
	end

	private

	def create_stripe_customer_with_subscription
		if self.plan.price > 0
			logger.info('Plan has a price!')
			begin
				logger.info('Beginning stripe request!')
				stripe_customer = Stripe::Customer.create(
					:source => self.token,
					:plan => self.plan.slug,
					:email => self.admin.email
				)
				self.external_id = stripe_customer.id
				logger.info('create customer response!')
				logger.info(stripe_customer.inspect)
			rescue  Stripe::CardError, Stripe::StripeError,
					Stripe::APIConnectionError, Stripe::AuthenticationError,
					Stripe::InvalidRequestError, Stripe::RateLimitError => e
				body = e.json_body
				err  = body[:error]
				self.errors.add(:base, err[:type].to_sym, message: err[:message])
				raise ActiveRecord::RecordInvalid.new(self)
			rescue => e
				self.errors.add(:base, :error, e)
				raise ActiveRecord::RecordInvalid.new(self)
			end
		else
			logger.info('Price was zero, Stripe subscription not created.')
		end
	end

	def create_stripe_customer
		begin
			stripe_customer = Stripe::Customer.create(
				:source => self.token,
				:email => self.admin.email
			)
			self.external_id = stripe_customer.id
			logger.info('create customer response!')
			logger.info(stripe_customer.inspect)
		rescue  Stripe::CardError, Stripe::StripeError,
				Stripe::APIConnectionError, Stripe::AuthenticationError,
				Stripe::InvalidRequestError, Stripe::RateLimitError => e
			body = e.json_body
			err  = body[:error]
			self.errors.add(:base, err[:type].to_sym, message: err[:message])
			raise ActiveRecord::RecordInvalid.new(self)
		rescue => e
			self.errors.add(:base, :error, e)
			raise ActiveRecord::RecordInvalid.new(self)
		end
	end

	def create_customer_subscription
		subscription = Subscription.new(customer: self)
		subscription.plan = self.plan
		if subscription.save
			
		else
			raise ActiveRecord::RecordInvalid.new(self)
		end
	end

	def destroy_stripe_customer
		cu = Stripe::Customer.retrieve(self.external_id)
		cu.delete
	end
end
