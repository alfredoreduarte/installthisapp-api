class CatalogMedium < ActiveRecord::Base
	self.table_name = "module_catalog_media"
	belongs_to 	:application

	def original
		return self.attachment_url
	end

	def thumbnail
		return self.attachment_url
	end
end
