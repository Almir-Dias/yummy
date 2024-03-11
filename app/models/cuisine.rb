class Cuisine < ApplicationRecord
  has_many :restaurant_cuisines, dependent: :destroy
  has_many :restaurants, through: :restaurant_cuisines

end
