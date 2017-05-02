class CatalogProduct < ActiveRecord::Base
	self.table_name = "module_catalog_products"
	enum status: { draft: 0, published: 1, deleted: 2 }
	belongs_to 	:application
end
