class FbPage < ApplicationRecord
	has_and_belongs_to_many :admin_users
	has_many :applications
	validates_uniqueness_of  :identifier

	def self.save_basic_data(data)
		fb_page = FbPage.find_or_initialize_by(identifier: data.id)
		fb_page.name = data.name
		fb_page.fan_count = data.raw_attributes["country_page_likes"].nil? ? data.likes_count.to_i : data.raw_attributes["country_page_likes"].to_i
		fb_page.save
		return fb_page
	end
end
