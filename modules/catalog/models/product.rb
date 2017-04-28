class CatalogProduct < ActiveRecord::Base
	self.table_name = "module_catalog_products"
	belongs_to 	:application
end
