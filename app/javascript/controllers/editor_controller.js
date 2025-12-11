import { Controller } from "@hotwired/stimulus"
import { EditorView, keymap, lineNumbers, highlightActiveLine, highlightActiveLineGutter } from "@codemirror/view"
import { EditorState } from "@codemirror/state"
import { defaultKeymap, history, historyKeymap } from "@codemirror/commands"
import { syntaxHighlighting, defaultHighlightStyle, bracketMatching, StreamLanguage } from "@codemirror/language"
import { ruby } from "@codemirror/legacy-modes/mode/ruby"
import { oneDark } from "@codemirror/theme-one-dark"

export default class extends Controller {
  static targets = ["editor", "input"]
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
      alert(data.message)
    })
    .catch(error => {
      console.error("Error:", error)
      alert("Error submitting solution")
    })
  }
}
