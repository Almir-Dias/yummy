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
      @restaurants = @restaurants.joins(:cuisine).where(cuisine: @cuisine)
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
    @descriptions = ["Um restaurante que se destaca por seus pratos exuberantemente coloridos e artisticamente apresentados, onde cada mordida é uma experiência sensorial que combina sabores, texturas e aromas de forma harmoniosa.",
    "Um estabelecimento conhecido por sua abordagem inovadora na culinária, onde os chefs são verdadeiros artistas, transformando ingredientes simples em obras-primas gastronômicas, surpreendendo os paladares mais exigentes.",
    "Um local onde a tradição se encontra com a criatividade, oferecendo uma seleção de pratos clássicos reinventados com um toque moderno, mantendo o sabor autêntico e a qualidade dos ingredientes frescos.",
    "Um restaurante que celebra a diversidade culinária, apresentando uma variedade de pratos inspirados em diferentes culturas e regiões do mundo, proporcionando uma experiência gastronômica global sem sair da mesa.",
    "Um espaço onde a simplicidade é elevada à perfeição, com uma seleção cuidadosamente elaborada de pratos que destacam ingredientes locais e sazonais, oferecendo uma culinária honesta e reconfortante.",
    "Um lugar onde a gastronomia é uma forma de arte, com pratos elaborados com maestria e apresentados com elegância, proporcionando uma experiência culinária que é ao mesmo tempo visualmente deslumbrante e deliciosamente satisfatória.",
    "Um restaurante que valoriza a qualidade acima de tudo, oferecendo uma seleção de pratos que são preparados com os melhores ingredientes disponíveis, garantindo um sabor excepcional em cada garfada.",
    "Um espaço que celebra a criatividade na cozinha, apresentando uma variedade de pratos que desafiam as convenções culinárias tradicionais, explorando novas combinações de sabores e técnicas de preparo.",
    "Um estabelecimento onde a paixão pela comida é evidente em cada detalhe, desde a seleção dos ingredientes até a apresentação dos pratos, oferecendo uma experiência gastronômica que é tanto emocionante quanto deliciosa.",
    "Um restaurante que busca inspiração na natureza, oferecendo uma culinária que reflete a abundância e diversidade dos ingredientes locais, apresentando pratos que são uma celebração dos sabores e texturas encontrados na terra e no mar."]
  end
end
