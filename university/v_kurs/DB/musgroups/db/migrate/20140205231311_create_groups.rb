class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.integer :formation_year
      t.string :country
      t.integer :top_position

      t.timestamps
    end
  end
end
