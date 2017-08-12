class FbLeadform < ApplicationRecord
	belongs_to :admin
	has_many :fb_lead_destinations

	before_create 	:subscribe_page

	private

	def subscribe_page
		fb_page = FbPage.find_by(identifier: self.fb_page_identifier)
		if fb_page
			fb_page.subscribe_to_realtime(self.admin)
		end
	end
end