class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.string :country
      t.string :city
      t.datetime :date
      t.integer :tour_id

      t.timestamps
    end
  end
end
