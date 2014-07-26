class AddReceiptIdToBillPositions < ActiveRecord::Migration
  def change
    add_column :bill_positions, :receipt_id, :integer
  end
end
