class FbLeadNotification
	Mongoid::QueryCache.enabled = true
	include Mongoid::Document
	include Mongoid::Timestamps

	field :lead_id, type: String
	field :fb_lead_destination_id, type: Integer
	field :success, type: Boolean
	field :retries, type: Integer, default: 0
	field :created_time, type: DateTime
end