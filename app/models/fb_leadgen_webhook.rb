class FbLeadgenWebhook
	Mongoid::QueryCache.enabled = true
	include Mongoid::Document
	include Mongoid::Timestamps

	field :ad_id, type: Integer
	field :form_id, type: Integer
	field :leadgen_id, type: Integer
	field :created_time, type: Integer
	field :page_id, type: Integer
	field :adgroup_id, type: Integer

	field :processed, type: Boolean, default: false
end