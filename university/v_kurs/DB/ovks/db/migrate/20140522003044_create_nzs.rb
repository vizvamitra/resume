class CreateNzs < ActiveRecord::Migration
  def change
    create_table :nzs do |t|
      t.string :ovks_num
      t.datetime :date
      t.string :contract_num
      t.string :code
      t.string :destination
      t.string :apk_name
      t.string :decimal_num
      t.string :zav_num
      t.datetime :buy_till
      t.string :manager
      t.string :sp_si
      t.string :scan
      t.string :given_to
      t.string :note

      t.timestamps
    end
  end
end
