class CatalogCategory < ActiveRecord::Base
	self.table_name = "module_catalog_categories"
	acts_as_nested_set
	belongs_to 	:application
end