class CreateReceiptsSzs < ActiveRecord::Migration
  def change
    create_table :receipts_szs, id: false do |t|
      t.belongs_to :receipt
      t.belongs_to :sz
    end
  end
end
