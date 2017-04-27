class CreateModuleCatalogMedia < ActiveRecord::Migration[5.0]
	def change
		create_table :module_catalog_media do |t|
			t.string :attachment_url
			t.string :attachment_type
			t.string :attachment_alt
			t.references :application, foreign_key: true

			t.timestamps
		end
	end
end
