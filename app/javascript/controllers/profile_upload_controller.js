import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "submit", "loading"]

  connect() {
    this.originalButtonText = this.submitTarget.value
  }

  preview() {
    const file = this.inputTarget.files[0]
    if (file) {
      this.loadingTarget.classList.remove("hidden")
      this.previewTarget.classList.add("opacity-50")
      this.submitTarget.disabled = true

      const reader = new FileReader()
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result
        this.previewTarget.classList.remove("opacity-50")
        this.loadingTarget.classList.add("hidden")
        this.submitTarget.disabled = false
      }
      reader.readAsDataURL(file)
    }
  }

  submit() {
    this.submitTarget.disabled = true
    this.submitTarget.value = "Saving..."
    this.submitTarget.classList.add("opacity-75", "cursor-not-allowed")
  }
}
