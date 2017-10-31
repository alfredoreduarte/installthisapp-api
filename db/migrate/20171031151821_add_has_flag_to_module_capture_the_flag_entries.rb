class AddHasFlagToModuleCaptureTheFlagEntries < ActiveRecord::Migration[5.0]
  def change
  	add_column :module_capture_the_flag_entries, :has_flag, :boolean, default: false, after: :elapsed_seconds
  end
end
