class CreateJoinTableApplicationFbPage < ActiveRecord::Migration[5.0]
  def change
    create_join_table :applications, :fb_pages do |t|
      # t.index [:application_id, :fb_page_id]
      # t.index [:fb_page_id, :application_id]
    end
  end
end
