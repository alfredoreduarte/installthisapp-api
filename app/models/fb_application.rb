class FbApplication < ApplicationRecord
	has_many  :applications
	
	validates_uniqueness_of :app_id

	validates_presence_of :app_id, :secret_key, :namespace
end
