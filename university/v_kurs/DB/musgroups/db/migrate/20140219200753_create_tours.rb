class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.string :title
      t.integer :group_id

      t.timestamps
    end
  end
end
