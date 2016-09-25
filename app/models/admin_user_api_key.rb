class AdminUserApiKey < ApplicationRecord
	before_create :generate_token
	belongs_to :admin_user
	
	private

	def generate_token
		begin
			self.token = SecureRandom.hex
		end while self.class.exists?(token: token)
	end
end
