class FbLead
	Mongoid::QueryCache.enabled = true
	include Mongoid::Document
	include Mongoid::Timestamps

	field :leadgen_id, type: String
	field :ad_id, type: String
	field :form_id, type: String
	field :created_time, type: DateTime
	field :field_data, type: Array
end