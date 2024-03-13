class AddReferanceToFavorites < ActiveRecord::Migration[7.1]
  def change
    add_reference :favorites, :restaurant, foreign_key: true
  end
end
