class Admin < ActiveRecord::Base
	# Include default devise modules.
	devise :database_authenticatable, :registerable,
	      :recoverable, :rememberable, :trackable, :validatable,
	      :confirmable, :omniauthable
	include DeviseTokenAuth::Concerns::User
	has_one :fb_profile
	has_many :applications, -> {where.not(status: :deleted)}
end
