class CatalogMedium < ActiveRecord::Base
	self.table_name = "module_catalog_media"
	belongs_to 	:application
end
