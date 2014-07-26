class AddIndexToReceipts < ActiveRecord::Migration
  def change
    add_index :receipts, :ovks_num, unique: true
  end
end
