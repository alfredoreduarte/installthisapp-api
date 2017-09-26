class AddFbFormNameToFbLeadforms < ActiveRecord::Migration[5.0]
  def change
  	add_column :fb_leadforms, :fb_form_name, :string, after: :fb_form_id
  end
end
