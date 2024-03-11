class RestaurantCuisine < ApplicationRecord
  belongs_to :restaurant
  belongs_to :cuisine

  validates :restaurant, uniqueness: {scope: :cuisine}
end
