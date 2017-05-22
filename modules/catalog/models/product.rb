class CatalogProduct < ActiveRecord::Base
	self.table_name = "module_catalog_products"
	enum status: { draft: 0, published: 1, deleted: 2 }
	belongs_to 	:application
	has_many 	:messages, class_name: "CatalogMessage", foreign_key: :product_id, dependent: :destroy
	before_save :sanitize_slug
	before_save :sanitize_category_ids
	before_save :sanitize_image_ids

	def categories
		return CatalogCategory.find(self.category_ids)
	end

	def media
		return CatalogMedium.find([self.featured_image_id] + self.gallery_media_ids)
	end

	def featured_image
		return CatalogMedium.find(self.featured_image_id)
	end

	def permalink
		return "/#{self.application.fb_application.canvas_id}/#{self.application.checksum}/#{self.slug}"
	end

	def sanitize_slug
		slug = self.slug ? self.slug : self.name
		self.slug = slug.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
	end

	def sanitize_category_ids
		category_ids = self.category_ids.map(&:to_i)
		category_ids = category_ids.uniq
		self.category_ids = category_ids
	end

	def sanitize_image_ids
		gallery_media_ids = self.gallery_media_ids.map(&:to_i)
		gallery_media_ids = gallery_media_ids.uniq
		self.gallery_media_ids = gallery_media_ids
	end
end
