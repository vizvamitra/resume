class CreateSzs < ActiveRecord::Migration
  def change
    create_table :szs do |t|
      t.string :ovks_num
      t.datetime :date
      t.string :type
      t.integer :employee_id
      t.boolean :done
      t.string :scan
      t.integer :user_id
      t.string :note

      t.timestamps
    end
  end
end
