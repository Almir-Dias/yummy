
class PlacesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]

  def show
    @place = Place.find(params[:id])
  end

  def index
    @places = Place.all
  end

end
