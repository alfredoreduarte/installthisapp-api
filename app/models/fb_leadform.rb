class FbLeadform < ApplicationRecord
	belongs_to :admin
	has_many :fb_lead_destinations

	validates :fb_page_identifier, :fb_form_id, presence: true

	before_create 	:subscribe_page

	private

	def subscribe_page
		fb_page = FbPage.find_by(identifier: self.fb_page_identifier)
		unless fb_page.webhook_subscribed
			fb_page.subscribe_to_realtime(self.admin)
		end
	end
end