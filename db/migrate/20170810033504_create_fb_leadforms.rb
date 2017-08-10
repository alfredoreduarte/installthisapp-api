class CreateFbLeadforms < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_leadforms do |t|
      t.string :fb_page_identifier
      t.string :fb_form_id
      t.references :admin, foreign_key: true

      t.timestamps
    end
  end
end
