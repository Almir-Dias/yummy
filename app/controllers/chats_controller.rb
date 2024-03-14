require 'httparty'
# require 'openai'


class ChatsController < ApplicationController
  def index
    @cuisines = Cuisine.all
    weather = fetch_weather(-23.570921, -46.649910)
    if weather
      response = generate_response(weather)
      @cuisines = Cuisine.where(name: response)
    end
  end

  private

  def fetch_weather(latitude, longitude)
    api_key = ENV.fetch('API_WEATHER')
    url = "https://api.weatherapi.com/v1/current.json?key=#{api_key}&q=#{latitude},#{longitude}"
    response = HTTParty.get(url)
    if response.code == 200
      data = JSON.parse(response.body)
      weather_description = data['current']['condition']['text']
      temperature = data['current']['temp_c']
      "O tempo em São Paulo é #{weather_description} com temperatura de #{temperature}°C."
    else
      nil
    end
  end
  
  def generate_response(weather_prompt)
    possible_cuisines = @cuisines.map do |cuisine|
      cuisine.name
    end
    possible_cuisines = possible_cuisines.join(', ')
    client = OpenAI::Client.new
    begin  
      chaptgpt_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: "#{weather_prompt}. Sabendo disso, quais dessas opções de restaurantes, e apenas essas opções, são as mais ideias a serem visitadas? #{possible_cuisines}. Eu quero que você me retorne apenas uma array com as opções ideais, sem mais nenhum texto adicional."}]
      })
      chaptgpt_response["choices"][0]["message"]["content"].tr("/\"[] ", "").split(',')
    rescue
      possible_cuisines.tr(" ", "").split(',')  
    end
  end
end
