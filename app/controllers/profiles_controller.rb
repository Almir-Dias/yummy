class ProfilesController < ApplicationController
  def show
    @user=current_user
    @animate = :profile
  end
end
