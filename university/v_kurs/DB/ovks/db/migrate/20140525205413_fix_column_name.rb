class FixColumnName < ActiveRecord::Migration
  def self.up
    rename_column :szs, :type, :sz_type_id
  end

  def self.down
    rename_column :szs, :sz_type_id, :type
  end
end
