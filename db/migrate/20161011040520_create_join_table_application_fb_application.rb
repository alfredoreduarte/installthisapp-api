class CreateJoinTableApplicationFbApplication < ActiveRecord::Migration[5.0]
  def change
    create_join_table :applications, :fb_applications do |t|
      # t.index [:application_id, :fb_application_id]
      # t.index [:fb_application_id, :application_id]
    end
  end
end
