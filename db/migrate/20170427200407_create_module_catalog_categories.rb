class CreateModuleCatalogCategories < ActiveRecord::Migration[5.0]
	def change
		create_table :module_catalog_categories do |t|
			# Mandatory fields for the awesome_nested_set gem
			t.string :name
			t.integer :parent_id, null: true, index: true
			t.integer :lft, null: false, index: true
			t.integer :rgt, null: false, index: true
			# Optional fields
			t.integer :depth, null: false, default: 0
			t.integer :children_count, null: false, default: 0

			# Custom fields
			t.integer :featured_image_id
			t.string :slug

			t.references :application, foreign_key: true

			t.timestamps
		end
	end
end
