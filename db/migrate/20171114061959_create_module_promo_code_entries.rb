class CreateModulePromoCodeEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :module_promo_code_entries do |t|
    	t.string :code
		t.references :application, foreign_key: true
		t.references :fb_user, foreign_key: true
		t.timestamps
    end
  end
end
