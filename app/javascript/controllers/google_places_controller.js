import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="google-places"
export default class extends Controller {
  // static targets = ['list'];

  connect() {
    // Vai todo o codigo que vai ser executado quando o controlador carrega, fetch sera carregado
    const url = `https://places.googleapis.com/v1/places:searchNearby`
    fetch(url, {headers: 
      {"Accept": "text/plain",
      "Method": "POST",
      "mode": "no-cors",
      "X-Goog-Api-Key": "AIzaSyBrKLcoXPvH7BeUDFM71rQqjELGp7I_etM",
      "X-Goog-FieldMask": "places.displayName, places.formattedAddress, places.photos, places.allowDogs"}
    })
      .then(response => response.text())
      .then((data) => {
        // this.listTarget.outerHTML = data;
        console.log(data);
    })
  }
  
  // apos  o filtro, fetch sera carregado
  
  loadFilters() {
    
  }
}
