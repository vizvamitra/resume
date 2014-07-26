class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.string :music_by
      t.string :lyrics_by
      t.integer :group_id

      t.timestamps
    end
  end
end