import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ['container', 'loading', 'list', 'weather'];

  connect() {
    navigator.geolocation.getCurrentPosition((position) => {
      this.getCustomRestaurants(position.coords.longitude, position.coords.latitude);
    }, () => {
      this.containerTarget.innerHTML = "<h1 class='text-center'>Por favor permita a localização</h1>";
    })
  }

  async getCustomRestaurants(longitude, latitude) {
    const recommendationResponse = await fetch(`/ai_recommendation?longitude=${longitude}&latitude=${latitude}`, {
      headers: { "Accept": "application/json" }
    });
    const recommendationData = await recommendationResponse.json();

    this.weatherTarget.innerText = recommendationData.weather;

    const restaurantsResponse = await fetch(`/custom_restaurants?longitude=${longitude}&latitude=${latitude}&cuisines=${recommendationData.cuisines.join(',')}`, {
      headers: { "Accept": "text/plain" }
    });
    const restaurantsData = await restaurantsResponse.text();

    this.loadingTarget.classList.add('d-none');
    this.weatherTarget.innerText= "Essas são as recomendações para você!";
    this.containerTarget.classList.remove('h-100');
    this.listTarget.innerHTML = restaurantsData;
  }
}
