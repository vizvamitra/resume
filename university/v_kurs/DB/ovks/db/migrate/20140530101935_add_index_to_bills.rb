class AddIndexToBills < ActiveRecord::Migration
  def change
    add_index :bills, :ovks_num, unique: true
  end
end
