class CreateModuleCouponsVouchers < ActiveRecord::Migration[5.0]
  def change
    create_table :module_coupons_vouchers do |t|
    	t.string :code, null: false
    	t.references :application, foreign_key: true
		t.references :fb_user, foreign_key: true
		t.timestamps
    end
  end
end
