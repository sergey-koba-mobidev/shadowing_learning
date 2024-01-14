import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (document.getElementById("phrase-audio")) {
      document.getElementById("phrase-audio").play()
    }
  }
  disconnect() {
    if (document.getElementById("phrase-audio")) {
      document.getElementById("phrase-audio").pause()
    }
  }
}
