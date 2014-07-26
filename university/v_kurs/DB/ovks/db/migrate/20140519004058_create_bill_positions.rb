class CreateBillPositions < ActiveRecord::Migration
  def change
    create_table :bill_positions do |t|
      t.integer :type_id
      t.string :model
      t.integer :count
      t.string :sn
      t.integer :bill_id
      t.integer :user_id

      t.timestamps
    end
  end
end
