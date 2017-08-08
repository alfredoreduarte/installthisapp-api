class Admin < ActiveRecord::Base
	# Include default devise modules.
	devise 	:database_authenticatable, :registerable,
			:recoverable, :rememberable, :trackable, :validatable,
			:confirmable, :omniauthable

	# TODO - BUG FIX
	# Des-comentar para staging, ver cómo arreglar para normalizar entre staging y producción
	# serialize :tokens, JSON
	# 
	include DeviseTokenAuth::Concerns::User
	has_one :fb_profile
	has_many :fb_pages, through: :fb_profile
	has_many :applications, -> {where.not(status: :deleted)}

	def subscription
		if ENV['FREE_ADMINS'].split(',').map(&:to_i).include?(self.id)
		# if true
			return Payola::Subscription.new(
				owner_id: self.id, 
				state: 'active',
				plan_id: 2
			)
		else
			return Payola::Subscription.find_by(owner_id: self.id, state: 'active')
			# return nil
		end
	end

	def has_subscription
		subscription = self.subscription
		if subscription 
			if subscription.active?
				return subscription.plan.stripe_id
			else
				return nil
			end
		else
			return nil
		end
	end

	def can(action)
		case action
			when :create_apps
				return true
			when :publish_apps
				# if self.has_subscription || ENV['FREE_ADMINS'].split(',').map(&:to_i).include?(self.id)
				if self.has_subscription
					return true
				else
					if self.created_at + 7.days > Time.now && self.applications.installed.length <= 2 # active free trial
						return true
					else # free trial expired
						return false
					end
				end
				return true
			when :invite_admins
				return true
			else
				return true
		end
	end
end

# class Admin::ParameterSanitizer < Devise::ParameterSanitizer
# 	def initialize(*)
# 		super
# 		permit(:sign_up, keys: [:confirm_success_url])
# 	end
# end