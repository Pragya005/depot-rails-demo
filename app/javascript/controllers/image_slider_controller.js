import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-slider"
export default class extends Controller {
  static targets = ["slide"]
  connect() {
    this.currentIndex = 0
  }

  next(){
    this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length
    this.showSlide()
  }

  previous(){
    this.currentIndex = (this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length
    this.showSlide()
  }

  showSlide(){
    this.slideTargets.forEach((slide, index) => {
      slide.classList.toggle("hidden", index !== this.currentIndex)
    })
  }
}
