class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.string :place_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
