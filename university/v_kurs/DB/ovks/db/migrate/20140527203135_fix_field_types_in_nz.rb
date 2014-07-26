class FixFieldTypesInNz < ActiveRecord::Migration
  def change
    change_column :nzs, :manager_id, :integer
    change_column :nzs, :given_to_id, :integer
  end
end
