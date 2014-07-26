class AddSzIdAndNzIdToBillPositions < ActiveRecord::Migration
  def change
    add_column :bill_positions, :sz_id, :integer
    add_column :bill_positions, :nz_id, :integer
  end
end
