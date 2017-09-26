class FbLeadform < ApplicationRecord
	belongs_to :admin
	has_many :fb_lead_destinations

	validates :fb_page_identifier, :fb_form_id, presence: true

	before_create 	:subscribe_page

	# TODO: add after_destroy action to unsubscribe page

	def get_existing_test_lead
		require 'fb_api'

		fb_profile = self.admin.fb_profile
		access_token = fb_profile.access_token

		if access_token
			read = FbApi::read_test_leads( self.fb_form_id, access_token )
			Rails.logger.info('EXISTING LEAD RESULT')
			Rails.logger.info(read.inspect)
			if read
				test_lead = read["data"].first
				return test_lead
			end
		end
	end

	def test
		require 'fb_api'

		fb_profile = self.admin.fb_profile
		access_token = fb_profile.access_token

		if access_token
			result = create_test_lead( self.fb_form_id, access_token )
			if result
				# Success
				if result["id"]
					# Rails.logger.info("will create fake notif")
					# fb_lead_notification = FbLeadNotification.create(
					# 	lead_id: result["id"],
					# 	fb_lead_destination_id: FbLeadDestination.first.id,
					# 	success: true,
					# 	retries: 0
					# )
					return result
				elsif result["error"]
				# elsif false
					# Handle error
					Rails.logger.info('New lead returned error')
					# Already has leads
					if result["error"]["code"].to_i == 2
						Rails.logger.info('Form already had a test lead')
						# Read existing test Leads
						read = FbApi::read_test_leads( self.fb_form_id, access_token )
						Rails.logger.info('and it is')
						Rails.logger.info(read)
						if read
							lead_id = read["data"].first["id"]
							# return read["data"].first
							if lead_id
								# Delete test lead
								deleted = FbApi::delete_test_lead( lead_id, access_token )
								if deleted
									if deleted["success"].to_s == "true"
										Rails.logger.info('Successfully deleted test lead')
										# Create new test lead
										test_lead = create_test_lead( self.fb_form_id, access_token )
										# return test_lead
										if test_lead
											# Success
											if test_lead["id"]
												# Rails.logger.info("will create fake notif")
												# fb_lead_notification = FbLeadNotification.create(
												# 	lead_id: test_lead["id"],
												# 	fb_lead_destination_id: FbLeadDestination.first.id,
												# 	success: true,
												# 	retries: 0
												# )
												return test_lead
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	def create_test_lead(fb_form_id, access_token)
		created = FbApi::send_test_lead( fb_form_id, access_token )
		Rails.logger.info('NEW LEAD RESULT')
		Rails.logger.info(created.inspect)
		return created
	end

	private

	def subscribe_page
		fb_page = FbPage.find_by(identifier: self.fb_page_identifier)
		# unless fb_page.webhook_subscribed
			fb_page.subscribe_to_realtime(self.admin)
		# end
	end
end