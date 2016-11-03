class Admin < ActiveRecord::Base
	# Include default devise modules.
	devise :database_authenticatable, :registerable,
	      :recoverable, :rememberable, :trackable, :validatable,
	      :confirmable, :omniauthable
	include DeviseTokenAuth::Concerns::User
	has_one :fb_profile
	has_many :fb_pages, through: :fb_profile
	has_one :customer
	has_one :subscription, through: :customer
	has_many :applications, -> {where.not(status: :deleted)}

	def has_subscription
		subscription = self.subscription
		if subscription && subscription.active_until > Time.now
			return subscription.plan.slug
		else
			return nil
		end
	end

	def can(action)
		case action
			when :create_apps
				return true
			else
				return true
		end
	end
end
