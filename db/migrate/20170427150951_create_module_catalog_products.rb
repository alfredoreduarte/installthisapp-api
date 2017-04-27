class CreateModuleCatalogProducts < ActiveRecord::Migration[5.0]
	def change
		create_table :module_catalog_products do |t|
			# Basic metadata
			t.string :name
			t.string :slug
			t.integer :status, default: 0
			t.boolean :featured, default: false
			
			# Product details
			t.text :description
			t.string :short_description

			# Price
			t.string :price
			t.string :regular_price
			t.string :sale_price

			# Sales
			t.datetime :on_sale_from
			t.datetime :on_sale_to

			# Order
			t.integer :menu_order

			# Product categories
			t.text :category_ids, array: true, default: []

			# Attached media
			t.integer :featured_image_id
			t.text :gallery_media_ids, array: true, default: []

			t.references :application, foreign_key: true

			t.timestamps
		end
	end
end
