class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def ai_recommendation
    longitude = params["longitude"]
    latitude = params["latitude"]
    @weather = fetch_weather(latitude, longitude)

    if @weather
      response = generate_response(@weather)
      if response
        respond_to do |format|
          format.json { render json: { cuisines: generate_response(@weather), weather: @weather }, status: :ok }
        end
      else
        respond_to do |format|
          format.json { render json: { error: "Could not fetch chat gpt" }, status: 500 }
        end
      end
    else
      respond_to do |format|
        format.json { render json: { error: "Could not fetch weather" }, status: 500 }
      end
    end
  end

  def custom_restaurants
    client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    longitude = params["longitude"]
    latitude = params["latitude"]
    cuisines_array = params["cuisines"].split(',')
    cuisines = Cuisine.where(name: cuisines_array)

    restaurants = []

    # Pegando só uma recomendação do gepetão no Google Places

    # spots = client.spots(latitude, longitude, :types => ['restaurant', 'food'], name: cuisines.first.name)

    # spots.each do |spot|
    #   spot_complete = client.spot(spot.reference)
    #   restaurant = Restaurant.new
    #   restaurant.name = spot_complete.name
    #   restaurant.address = spot_complete.formatted_address
    #   restaurant.rating = spot_complete.rating
    #   restaurant.photo_url = spot_complete.photos[0].fetch_url(200) if spot_complete.photos.present?
    #   restaurant.price = spot_complete.price_level
    #   restaurant.latitude = spot_complete.lat
    #   restaurant.longitude = spot_complete.lng
    #   restaurant.places_reference = spot_complete.reference
    #   restaurants << restaurant
    # end


    # Pegando todas as recomendações do gepetão no Google Maps

    cuisines.each do |cuisine|
      spots = client.spots(latitude, longitude, :types => ['restaurant', 'food'], name: cuisine.name)

      spots.first(3).each do |spot|
        spot_complete = client.spot(spot.reference)
        restaurant = Restaurant.new
        restaurant.name = spot_complete.name
        restaurant.address = spot_complete.formatted_address
        restaurant.rating = spot_complete.rating
        restaurant.photo_url = spot_complete.photos[0].fetch_url(200) if spot_complete.photos.present?
        restaurant.price = spot_complete.price_level
        restaurant.latitude = spot_complete.lat
        restaurant.longitude = spot_complete.lng
        restaurant.places_reference = spot_complete.reference
        restaurants << restaurant
      end
    end

    # Puxando da nossa base de dados
    # restaurants = Restaurant.where(cuisine: cuisines)

    respond_to do |format|
      format.text { render partial: 'restaurants/card', collection: restaurants.shuffle, as: :restaurant, locals: { favorite: nil }, formats: [:html] }
    end
  end

  private

  def fetch_weather(latitude, longitude)
    api_key = ENV.fetch('API_WEATHER')
    url = "https://api.weatherapi.com/v1/current.json?key=#{api_key}&q=#{latitude},#{longitude}&lang=pt"
    response = HTTParty.get(url)
    if response.code == 200
      data = JSON.parse(response.body)
      weather_description = data['current']['condition']['text']
      temperature = data['current']['temp_c']
      "Olá! Está #{weather_description.downcase} em São Paulo e a temperatura é de #{temperature}°C. Estou buscando alguns restaurantes interessantes nas redondezas."
    else
      nil
    end
  end

  def generate_response(weather_prompt)
    cuisines = Cuisine.all
    possible_cuisines = cuisines.map do |cuisine|
      cuisine.name
    end
    possible_cuisines = possible_cuisines.join(', ')
    client = OpenAI::Client.new
    possible_cuisines.tr(" ", "").split(',')
    begin
      chaptgpt_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: "#{weather_prompt}. Sabendo disso, quais dessas opções de restaurantes, e apenas essas opções e mais nenhuma que não sejam essas, são as mais ideais a serem visitadas? #{possible_cuisines}. Eu quero que você me retorne apenas uma array com as opções ideais, sem mais nenhum texto adicional."}]
      })
      chaptgpt_response["choices"][0]["message"]["content"].tr("/\"[]' ", "").split(',')
    rescue
      possible_cuisines.tr(" ", "").split(',')
    end
  end
end
