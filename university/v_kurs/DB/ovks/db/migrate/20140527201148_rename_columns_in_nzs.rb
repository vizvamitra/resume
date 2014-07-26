class RenameColumnsInNzs < ActiveRecord::Migration
  def self.up
    rename_column :nzs, :manager, :manager_id
    rename_column :nzs, :given_to, :given_to_id
  end

  def self.down
    rename_column :nzs, :manager_id, :manager
    rename_column :nzs, :given_to_id, :given_to
  end
end
