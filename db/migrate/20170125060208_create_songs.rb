class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :recommendor
      t.string :color

      t.timestamps
    end
  end
end
