class CreateJoinTableFbProfileFbPage < ActiveRecord::Migration[5.0]
  def change
    create_join_table :fb_profiles, :fb_pages do |t|
      # t.index [:fb_profile_id, :fb_page_id]
      # t.index [:fb_page_id, :fb_profile_id]
    end
  end
end
