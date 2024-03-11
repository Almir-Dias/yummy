import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="google-places"
export default class extends Controller {
  // static targets = ['list'];

  connect() {
    console.log("oieeeee");
    // Vai todo o codigo que vai ser executado quando o controlador carrega, fetch sera carregado
    const proxyurl = "https://cors-anywhere.herokuapp.com/";
    const url = `https://places.googleapis.com/v1/places:searchNearby`;
    const body = {
      "includedTypes": ["restaurant"],
      "locationRestriction": {
          "circle": {
              "center": {
                  "latitude": -23.58398991363618,
                  "longitude": -46.685895111093835
              },
          "radius": 1000.0
          }
      }
    };

    fetch(proxyurl + url, {
      method: "POST",
      headers: {"Accept": "text/plain",
        "mode": "no-cors",
        "X-Goog-Api-Key": "AIzaSyBrKLcoXPvH7BeUDFM71rQqjELGp7I_etM",
        "X-Goog-FieldMask": "places.displayName"
      },
      body: JSON.stringify(body)
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

  // handleClick() {
  //   alert("Botão clicado!");
  //   // Adicione aqui o código que deseja executar quando o botão for clicado
  //   console.log("botão clicado")
  // }
