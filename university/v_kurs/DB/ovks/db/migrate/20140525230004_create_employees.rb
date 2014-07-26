class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :fio
      t.string :phone
      t.integer :department_id
      t.string :post

      t.timestamps
    end
  end
end
