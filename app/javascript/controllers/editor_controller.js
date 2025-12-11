import { Controller } from "@hotwired/stimulus"
import { EditorView, keymap, lineNumbers, highlightActiveLine, highlightActiveLineGutter } from "@codemirror/view"
import { EditorState } from "@codemirror/state"
import { defaultKeymap, history, historyKeymap } from "@codemirror/commands"
import { syntaxHighlighting, defaultHighlightStyle, bracketMatching, StreamLanguage } from "@codemirror/language"
import { ruby } from "@codemirror/legacy-modes/mode/ruby"
import { oneDark } from "@codemirror/theme-one-dark"

export default class extends Controller {
  static targets = ["editor", "input"]

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
}
