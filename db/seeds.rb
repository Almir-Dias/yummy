Restaurant.destroy_all
Cuisine.destroy_all

Cuisine.create!(name: "Japonesa")
Cuisine.create!(name: "Pizza")
Cuisine.create!(name: "Lanches")
Cuisine.create!(name: "Italiana")
Cuisine.create!(name: "Mexicana")
Cuisine.create!(name: "Vegana")
Cuisine.create!(name: "Tailandesa")
Cuisine.create!(name: "Indiana")
Cuisine.create!(name: "Peruana")
Cuisine.create!(name: "Brasileira")


# https://github.com/qpowell/google_places
# First register a new Client:
# @client = GooglePlaces::Client.new(API_KEY)
# Then retrieve a list of spots:
# @client.spots(-33.8670522, 151.1957362)
# Search by a specific type:
# @client.spots(-33.8670522, 151.1957362, :types => 'restaurant')

client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])

positions = [[-23.5465, -46.6908],
             [-23.5709, -46.6499]]


positions.each do |position|
  Cuisine.first(3).each do |cuisine|
    puts "buscando restaurante #{cuisine.name}"

    spots = client.spots(position[0], position[1], :types => ['restaurant', 'food'], name: cuisine.name)
    puts "encontrado #{spots.count} restaurantes"

    spots.each do |spot|
      spot_complete = client.spot(spot.reference)
      restaurant = Restaurant.new
      restaurant.name = spot_complete.name
      restaurant.address = spot_complete.formatted_address
      restaurant.rating = rand(1..5)
      restaurant.photo_url = spot_complete.photos[0].fetch_url(200) if spot_complete.photos.present?
      restaurant.price = spot_complete.price_level
      restaurant.latitude = spot_complete.lat
      restaurant.longitude = spot_complete.lng
      restaurant.places_reference = spot_complete.reference
      if restaurant.save
        puts "criando restaurante #{spot_complete.name}"
      end

      restaurant.cuisines << cuisine
      restaurant.save
      if restaurant.save
        puts "adicionou restaurante #{spot_complete.name} na cuisine #{cuisine.name} "
      end
    end
  end
end
