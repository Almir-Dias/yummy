class FavoritesController < ApplicationController

  def index
    @favorites = current_user.favorites
  end

  def create
    @favorite = current_user.favorites.build(favorite_params)
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
