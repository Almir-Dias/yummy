class Restaurant < ApplicationRecord
  geocoded_by :address

  has_many :restaurant_cuisines, dependent: :destroy
  has_many :cuisines, through: :restaurant_cuisines
  has_many :favorites, dependent: :destroy

  validates :name, :address, :rating, :latitude, :longitude, :places_reference, presence: true
  validates :places_reference, uniqueness: true
  after_validation :geocode, if: :will_save_change_to_address?
end
