class CreateSzTypes < ActiveRecord::Migration
  def change
    create_table :sz_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
