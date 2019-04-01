import {Controller} from 'stimulus'

export default class extends Controller {
  static targets = ['burger', 'options']

  connect () {
    // TODO: implement "no-js" menu
    if (document.documentElement.classList) {
      this.burgerTarget.classList.remove('is-hidden')
    }
  }

  toggle () {
    this.burgerTarget.classList.toggle('is-active')
    this.optionsTarget.classList.toggle('is-active')
  }
}
