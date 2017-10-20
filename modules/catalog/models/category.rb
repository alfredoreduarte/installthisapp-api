class CatalogCategory < ActiveRecord::Base
	self.table_name = "module_catalog_categories"
	acts_as_nested_set :counter_cache => :children_count
	belongs_to 	:application
	before_save :sanitize_slug

	def permalink
		return "/catalog/#{self.application.checksum}/categories/#{self.slug}"
	end

	def sanitize_slug
		slug = self.slug ? self.slug : self.name
		self.slug = slug.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
	end
end
