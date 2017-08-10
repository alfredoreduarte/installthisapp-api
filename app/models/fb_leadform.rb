class FbLeadform < ApplicationRecord
	belongs_to :admin
	belongs_to :fb_profile
	has_and_belongs_to_many :fb_lead_destinations
end
