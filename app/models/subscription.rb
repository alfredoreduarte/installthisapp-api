class Subscription < ApplicationRecord
	require "stripe"
	belongs_to :customer
	belongs_to :plan
	before_create :create_stripe_subscription
	# before_update :update_stripe_subscription
	before_destroy :cancel_stripe_subscription

	attr_accessor :token

	def cancel_stripe_subscription
		begin
			subscription = Stripe::Subscription.retrieve(self.external_id)
			# subscription.delete(at_period_end: true)
			subscription.delete
		rescue  Stripe::CardError, Stripe::StripeError,
				Stripe::APIConnectionError, Stripe::AuthenticationError,
				Stripe::InvalidRequestError, Stripe::RateLimitError => e
			body = e.json_body
			err  = body[:error]
			logger.error('error!')
			logger.error(err)
			self.errors.add(:base, err[:type].to_sym, message: err[:message])
			raise ActiveRecord::RecordInvalid.new(self)
		rescue => e
			self.errors.add(:base, :error, e)
			raise ActiveRecord::RecordInvalid.new(self)
		end
	end

	# private

	def update_stripe_subscription
		if self.plan.price > 0
			begin
				subscription = Stripe::Subscription.retrieve(self.external_id)
				subscription.plan = self.plan.slug
				subscription.save
			rescue  Stripe::CardError, Stripe::StripeError,
					Stripe::APIConnectionError, Stripe::AuthenticationError,
					Stripe::InvalidRequestError, Stripe::RateLimitError => e
				body = e.json_body
				err  = body[:error]
				logger.error('error!')
				logger.error(err)
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

	def create_stripe_subscription
		if self.plan.price > 0
			begin
				logger.info('Beginning subscription stripe request!')
				stripe_subscription = Stripe::Subscription.create(
					:customer => self.customer.external_id,
					:plan => self.plan.slug,
				)
				self.external_id = stripe_subscription.id
				self.active_until = Time.at(stripe_subscription.current_period_end).utc
				logger.info('create subscription response!')
				logger.info(stripe_subscription.inspect)
			rescue  Stripe::CardError, Stripe::StripeError,
					Stripe::APIConnectionError, Stripe::AuthenticationError,
					Stripe::InvalidRequestError, Stripe::RateLimitError => e
				body = e.json_body
				err  = body[:error]
				logger.error('error!')
				logger.error(err)
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
end
