class CreateRestaurants < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.integer :rating
      t.string :photo_url
      t.float :latitude
      t.float :longitude
      t.string :places_reference

      t.timestamps
    end
  end
end
