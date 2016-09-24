class CreateJoinTableAdminUserFbPage < ActiveRecord::Migration[5.0]
  def change
    create_join_table :admin_users, :fb_pages do |t|
      # t.index [:admin_user_id, :fb_page_id]
      # t.index [:fb_page_id, :admin_user_id]
    end
  end
end
