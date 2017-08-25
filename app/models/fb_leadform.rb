class FbLeadform < ApplicationRecord
	belongs_to :admin
	has_many :fb_lead_destinations

	validates :fb_page_identifier, :fb_form_id, presence: true

	before_create 	:subscribe_page

	# TODO: add after_destroy action to unsubscribe page

	def test
		require 'fb_api'

		fb_profile = self.admin.fb_profile
		access_token = fb_profile.access_token # !!

		if access_token
			result = FbApi::send_test_lead( self.fb_form_id, access_token )
			if result
				if result["error"]["code"].to_i == 2
					# Read existing test Leads
					read = FbApi::read_test_leads( self.fb_form_id, access_token )
					if read
						lead_id = read["data"].first["id"]
						if lead_id
							# Delete test lead
							deleted = FbApi::delete_test_lead( lead_id, access_token )
							if deleted
								if deleted["success"].to_s == "true"
									# Create new test lead
									new_result = FbApi::send_test_lead( self.fb_form_id, access_token )
									Rails.logger.info('NEW RESULT')
									Rails.logger.info(new_result.inspect)
								end
							end
						end
					end
				end
			end
		end
	end

	private

	def subscribe_page
		fb_page = FbPage.find_by(identifier: self.fb_page_identifier)
		unless fb_page.webhook_subscribed
			fb_page.subscribe_to_realtime(self.admin)
		end
	end
end