class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @spots = []

    if params[:name].present?
      @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
      @spots = @client.spots(params[:lat].to_f, params[:lng].to_f, :types => ['restaurant', 'food'], name: params['name'])
    end
  end

end
