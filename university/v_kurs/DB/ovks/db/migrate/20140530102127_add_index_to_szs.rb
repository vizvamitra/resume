class AddIndexToSzs < ActiveRecord::Migration
  def change
    add_index :szs, :ovks_num, unique: true
  end
end
