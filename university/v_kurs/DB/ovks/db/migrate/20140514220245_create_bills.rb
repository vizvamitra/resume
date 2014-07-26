class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :ovks_num
      t.string :bill_num
      t.timestamp :bill_date
      t.integer :vendor_id
      t.float :total_sum
      t.timestamp :payment_date
      t.string :skan

      t.timestamps
    end
  end
end
