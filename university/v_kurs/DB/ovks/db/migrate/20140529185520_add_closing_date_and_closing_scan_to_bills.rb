class AddClosingDateAndClosingScanToBills < ActiveRecord::Migration
  def change
    add_column :bills, :closing_date, :datetime
    add_column :bills, :closing_skan, :string
  end
end
