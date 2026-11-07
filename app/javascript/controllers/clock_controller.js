import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clock"
export default class extends Controller {
  static targets = [ "time" ]
  connect() {
    this.updateTime()
    this.interval = setInterval(() => this.updateTime(), 1000)
  }

  updateTime() {
    const now = new Date()
    const formattedTime = now.toLocaleTimeString()
    this.timeTarget.textContent = formattedTime
  }

  disconnect() {
    clearInterval(this.interval)
  }
}
