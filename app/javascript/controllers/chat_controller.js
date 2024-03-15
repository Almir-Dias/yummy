import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ['container', 'loading', 'list'];

  connect() {
    navigator.geolocation.getCurrentPosition((position) => {
      this.getCustomRestaurants(position.coords.longitude, position.coords.latitude);
    }, () => {
      this.containerTarget.innerHTML = "<h1>Please accept geolocation</h1>";
    })
  }

  async getCustomRestaurants(longitude, latitude) {
    const response = await fetch(`/custom_restaurants?longitude=${longitude}&latitude=${latitude}`, {
      headers: { "Accept": "text/plain" }
    });
    const data = await response.text();

    this.loadingTarget.classList.add('d-none');
    this.containerTarget.classList.remove('h-100');
    this.listTarget.innerHTML = data;
  }
}
