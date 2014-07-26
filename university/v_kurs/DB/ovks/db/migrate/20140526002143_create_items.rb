class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :info
      t.boolean :done
      t.string :done_info
      t.integer :type_id
      t.integer :sz_id
      t.integer :nz_id

      t.timestamps
    end
  end
end
