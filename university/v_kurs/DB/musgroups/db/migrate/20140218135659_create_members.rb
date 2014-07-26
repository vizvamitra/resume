class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :role
      t.datetime :birth_date
      t.integer :group_id

      t.timestamps
    end
  end
end