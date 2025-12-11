import { Controller } from "@hotwired/stimulus"
import { EditorView, keymap, lineNumbers, highlightActiveLine, highlightActiveLineGutter } from "@codemirror/view"
import { EditorState } from "@codemirror/state"
import { defaultKeymap, history, historyKeymap } from "@codemirror/commands"
import { syntaxHighlighting, defaultHighlightStyle, bracketMatching, StreamLanguage } from "@codemirror/language"
import { ruby } from "@codemirror/legacy-modes/mode/ruby"
import { oneDark } from "@codemirror/theme-one-dark"
import confetti from "canvas-confetti"

export default class extends Controller {
  static targets = ["editor", "input", "modal", "modalTitle", "modalMessage", "solutionContainer", "solutionButton"]
  static values = { exerciseId: Number }

  connect() {
    console.log("Editor controller connected (Legacy Mode)")

    const initialContent = this.inputTarget.value

    const startState = EditorState.create({
      doc: initialContent,
      extensions: [
        lineNumbers(),
        highlightActiveLineGutter(),
        highlightActiveLine(),
        history(),
        bracketMatching(),
        keymap.of([...defaultKeymap, ...historyKeymap]),
        StreamLanguage.define(ruby),
        oneDark,
        EditorView.updateListener.of((update) => {
          if (update.docChanged) {
            this.inputTarget.value = update.state.doc.toString()
          }
        })
      ]
    })

    this.editor = new EditorView({
      state: startState,
      parent: this.editorTarget
    })
  }

  disconnect() {
    if (this.editor) {
      this.editor.destroy()
    }
  }

  checkSolution() {
    const code = this.inputTarget.value
    const exerciseId = this.exerciseIdValue
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    console.log("Submitting solution for Exercise", exerciseId)

    fetch(`/exercises/${exerciseId}/check_solution`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ code: code })
    })
    .then(response => response.json())
    .then(data => {
      console.log("Server response:", data)

      if (data.status === "success") {
        this.triggerConfetti()
        this.showModal("¡Excelente Trabajo! 🎉", data.message, true)
      } else {
        this.showModal("Ups, algo falló 😅", data.message, false)
      }
    })
    .catch(error => {
      console.error("Error:", error)
      this.showModal("Error de Conexión", "No pudimos contactar al servidor.", false)
    })
  }

  showModal(title, message, isSuccess) {
    this.modalTitleTarget.textContent = title
    this.modalMessageTarget.textContent = message

    // Color coding based on success/failure
    const titleClass = isSuccess ? "text-green-400" : "text-red-400"
    this.modalTitleTarget.className = `text-2xl font-bold mb-4 ${titleClass}`

    this.modalTarget.classList.remove("hidden")
  }

  closeModal() {
    this.modalTarget.classList.add("hidden")
  }

  triggerConfetti() {
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 }
    })
  }

  toggleSolution() {
    this.solutionContainerTarget.classList.toggle("hidden")

    if (this.solutionContainerTarget.classList.contains("hidden")) {
      this.solutionButtonTarget.textContent = "¿Ver solución?"
    } else {
      this.solutionButtonTarget.textContent = "Ocultar solución"
    }
  }
}
