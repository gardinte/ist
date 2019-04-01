import {Controller} from 'stimulus'

export default class extends Controller {
  static targets = ['close', 'message']

  connect () {
    if (Element.prototype.remove && document.documentElement.classList) {
      this.closeTargets.forEach(close => close.classList.remove('is-hidden'))
    }
  }

  close () {
    this.messageTarget.remove()
  }
}
