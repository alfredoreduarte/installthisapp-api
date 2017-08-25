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
			test_lead = FbApi::send_test_lead( self.fb_form_id, access_token )
			Rails.logger.info(test_lead.inspect)
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