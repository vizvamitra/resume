class AddBillIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :bill_id, :integer
  end
end
