class AddIndexToNzs < ActiveRecord::Migration
  def change
    add_index :nzs, :ovks_num, unique: true
  end
end
