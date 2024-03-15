class FavoritesController < ApplicationController

  def index
    @favorites = Favorite.where(user: current_user)
    @animate = :favorite
  end

  def create
    @favorite = Favorite.new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @favorite.restaurant = @restaurant
    @favorite.user = current_user

    if @favorite.save
      redirect_to favorites_path
    else
      render "restaurant/show"
    end
  end

  def show
    @favorite = Favorite.find(params[:id])
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to favorites_path, notice: 'Removido com sucesso.'
  end
end
