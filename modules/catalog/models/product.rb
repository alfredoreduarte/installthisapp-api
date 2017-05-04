class CatalogProduct < ActiveRecord::Base
	self.table_name = "module_catalog_products"
	enum status: { draft: 0, published: 1, deleted: 2 }
	belongs_to 	:application
	before_save :sanitize_category_ids

	def categories
		return CatalogCategory.find(self.category_ids)
	end

	def sanitize_category_ids
		category_ids = self.category_ids.map(&:to_i)
		category_ids = category_ids.uniq
		self.category_ids = category_ids
	end
end
