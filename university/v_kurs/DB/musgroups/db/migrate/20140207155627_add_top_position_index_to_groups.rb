class AddTopPositionIndexToGroups < ActiveRecord::Migration
  def change
  	add_index :groups, :top_position, :unique => true
  end
end
