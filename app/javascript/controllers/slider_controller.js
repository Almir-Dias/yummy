import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slider"
export default class extends Controller {
  static targets = ["input", "info"]
  static values = {
    type: String
  }
  connect() {
    this.update()
    console.log("ola tud bem?")
  }

  update() {
    if(this.typeValue === 'km') {
      this.infoTarget.innerText = `${this.inputTarget.value} km`
    } else if (this.typeValue === 'price') {
      this.infoTarget.innerText = '💸'.repeat(Number.parseInt(this.inputTarget.value))
    } else if (this.typeValue === 'star') {
      this.infoTarget.innerText = '⭐'.repeat(Number.parseInt(this.inputTarget.value))
    }
  }
}
