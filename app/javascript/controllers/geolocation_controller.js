import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="geolocation"
export default class extends Controller {

  static targets = ['lat', 'lng'];

  connect() {
    console.log("oie")
    console.log(this.latTarget)
    console.log(this.lngTarget)

    navigator.geolocation.getCurrentPosition((pos) => {
      this.latTarget.value = pos.coords.latitude;
      this.lngTarget.value = pos.coords.longitude;
    }, () => {},
    {
      enableHighAccuracy: true,
      timeout: 5000,
    });

    // this.success = this.success.bind(this);
    // this.error = this.error.bind(this);
  }

//   fetch_restaurants(position) {
//     const proxyurl = "https://cors-anywhere.herokuapp.com/";
//     const url = `https://places.googleapis.com/v1/places:searchNearby`;
//     const body = {
//       "includedTypes": ["restaurant"],
//       "locationRestriction": {
//           "circle": {
//               "center": {
//                   "latitude": position.latitude,
//                   "longitude": position.longitude
//               },
//           "radius": 100.0
//           }
//       }
//     };

//     console.log(body);

//     fetch(proxyurl + url, {
//       method: "POST",
//       headers: {"Accept": "text/plain",
//         "mode": "no-cors",
//         "X-Goog-Api-Key": "AIzaSyBrKLcoXPvH7BeUDFM71rQqjELGp7I_etM",
//         "X-Goog-FieldMask": "places.displayName"
//       },
//       body: JSON.stringify(body)
//     })
//       .then(response => response.text())
//       .then((data) => {
//         // this.listTarget.outerHTML = data;

//         console.log(data);
//         // for each
//         // insert.html
//     })
//   }

//   success(pos) {
//     const crd = pos.coords;

//     console.log('Your current position is:');
//     console.log(`Latitude : ${crd.latitude}`);
//     console.log(`Longitude: ${crd.longitude}`);
//     console.log(`More or less ${crd.accuracy} meters.`);

//     this.fetch_restaurants(crd);
//     // location.assign(`/locations?place=${crd.latitude},${crd.longitude}`)
//   }

//   error(err) {
//     console.warn(`ERROR(${err.code}): ${err.message}`);
//   }

//   search () {
//     navigator.geolocation.getCurrentPosition(this.success, this.error, options);
//   }
}

