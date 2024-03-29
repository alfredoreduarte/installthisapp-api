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
	has_many :fb_leadforms
	has_many :fb_lead_destinations
	has_many :fb_pages, through: :fb_profile
	has_many :applications, -> {where.not(status: :deleted)}

	def first_name
		self.name.blank? ? "" : self.name.split(" ")[0]
	end

	def subscription
		if ENV['FREE_ADMINS'].split(',').map(&:to_i).include?(self.id)
			return Payola::Subscription.new(
				owner_id: self.id, 
				state: 'active',
				plan_id: 2
			)
		else
			return Payola::Subscription.find_by(owner_id: self.id, state: 'active')
		end
	end

	def has_subscription
		return true if ENV['FREE_ADMINS'].split(',').map(&:to_i).include?(self.id)
		# 
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

	def can( action )
		case action
			when :create_apps
				return true
			when :publish_apps
				if self.has_subscription
					return true
				else
					if self.created_at + 7.days > Time.now && self.applications.installed.length <= 2 # active free trial
						return true
					else # free trial expired or app limit exceeded
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