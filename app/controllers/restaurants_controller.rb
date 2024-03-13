class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index

    if params[:lat].present? && params[:lng].present?
      @restaurants = Restaurant.near([params[:lat].to_f, params[:lng].to_f], 1)
    else
      @restaurants = Restaurant.where(rating: 4)
    end

    if params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @restaurants = @restaurants.joins(:cuisines).where(cuisines: @cuisine)
    end

    @restaurants = @restaurants.order(rating: :desc)

    @cuisines = Cuisine.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end
end
