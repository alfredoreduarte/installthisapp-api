class CaptureTheFlagEntry < ActiveRecord::Base
	self.table_name = "module_capture_the_flag_entries"
	belongs_to 	:application
	belongs_to 	:fb_user, class_name: "FbUser", foreign_key: :fb_user_id
end
