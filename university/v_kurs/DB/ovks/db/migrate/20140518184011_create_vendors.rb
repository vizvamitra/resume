class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :title
      t.string :address
      t.string :phone
      t.string :note

      t.timestamps
    end
  end
end
