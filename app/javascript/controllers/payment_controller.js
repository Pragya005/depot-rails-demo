import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payment"
export default class extends Controller {
  // Targets identify HTML elements that our controller will interact with
  static targets = ["selection", "additionalFields"]

  // initialize has the additional benefit of gracefully handing the case where the browser
  // restores the value of some form fields when the user manually refreshes
  // the browser window.

  initialize() {
    this.showAdditionalFields()
  }

  showAdditionalFields() {
    let selection = this.selectionTarget.value

    for (let fields of this.additionalFieldsTargets) {
      fields.disabled = fields.hidden = (fields.dataset.type != selection)
    }
  }
}
