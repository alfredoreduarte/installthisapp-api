class FormEntry < ActiveRecord::Base
	self.table_name = "module_form_entries"
	belongs_to 	:application
end
