class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.string :ovks_num
      t.string :scan
      t.datetime :date
      t.integer :employee_id
      t.integer :user_id
      t.string :note

      t.timestamps
    end
  end
end
