class AddSzOrNzToBillPositions < ActiveRecord::Migration
  def change
    add_column :bill_positions, :sz_or_nz, :boolean
  end
end
