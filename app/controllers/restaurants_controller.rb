class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index

    if params[:lat].present? && params[:lng].present?
      max_distance = 5
      # Busca os restaurantes dentro da distância especificada
      @restaurants = Restaurant.near([params[:lat].to_f, params[:lng].to_f, params[:distance].to_f], max_distance, units: :km)
    else
      @restaurants = Restaurant.all
    end

    if params[:cuisine_id].present?
      @cuisine = Cuisine.find(params[:cuisine_id])
      @restaurants = @restaurants.joins(:cuisines).where(cuisines: @cuisine)
    end


        # Filtra os restaurantes pela classificação (rating) dentro do intervalo de 1 a 5
        if params[:rating].present? && (1..5).include?(params[:rating].to_i)
          @restaurants = @restaurants.where(rating: params[:rating])
        end

        # Filtra os restaurantes pelo preço dentro do intervalo de 1 a 5
        if params[:price].present? && (1..5).include?(params[:price].to_i)
          @restaurants = @restaurants.where(price: params[:price])
        end

    @restaurants = @restaurants.order(rating: :desc)

    @cuisines = Cuisine.all


  end

  def map
    @restaurants = Restaurant.all
    @markers = @restaurants.geocoded.map do |restaurant|
      {
        lat: restaurant.latitude,
        lng: restaurant.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {restaurant: restaurant})
      }
    end
  end

  def filter

    # Exibe todos os tipos de cozinha para opções de filtro na view
    @cuisines = Cuisine.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end
end
