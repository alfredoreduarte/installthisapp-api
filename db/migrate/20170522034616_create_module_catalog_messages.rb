class CreateModuleCatalogMessages < ActiveRecord::Migration[5.0]
	def change
		create_table :module_catalog_messages do |t|
			t.string	 :email, null: false
			t.string	 :name
			t.string	 :phone
			t.text		 :content, null: false

			t.integer 	 :product_id, null: false
			t.references :fb_user, foreign_key: true # for future FB-login at catalog contact form
			t.references :application, foreign_key: true

			t.timestamps
		end
	end
end
