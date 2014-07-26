class ChangeFieldsSettingsInGroups < ActiveRecord::Migration
  def change
  	change_table :groups do |t|
  		t.change :title, :string, null: false
  		t.change :top_position, :integer, unique: true
  	end
  end
end
