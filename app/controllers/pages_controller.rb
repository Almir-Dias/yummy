class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @welcome_message = "Bem vindo ao nosso aplicativo"
  end
end
