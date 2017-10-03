class FormSchema < ActiveRecord::Base
	self.table_name = "module_form_schemas"
	belongs_to 	:application
end