class CatalogMedium < ActiveRecord::Base
	self.table_name = "module_catalog_media"
	belongs_to 	:application
	before_destroy :eliminate_from_products

	def original
		return self.attachment_url
	end

	def thumbnail
		return self.attachment_url
	end

	private

	def eliminate_from_products
		products = self.application.products
		for product in products
			# Gallery
			media_ids_array = product.gallery_media_ids
			media_ids_array.delete(self.id.to_s)
			product.gallery_media_ids = media_ids_array
			# Featured
			if product.featured_image_id == self.id
				product.featured_image_id = nil
			end
			product.save
		end
	end
end
