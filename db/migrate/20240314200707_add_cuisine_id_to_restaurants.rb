class AddCuisineIdToRestaurants < ActiveRecord::Migration[7.1]
  def change
    add_reference :restaurants, :cuisine, foreign_key: true
  end
end
