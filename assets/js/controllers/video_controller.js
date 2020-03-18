import {Controller} from 'stimulus'
import videojs from 'video.js'

export default class extends Controller {
  static targets = ['video']

  connect () {
    this.videoPlayer ||= videojs(this.videoTarget, {
      liveui: true,
      fluid:  true
    })

    if (this.data.get('fullscreen')) {
      this.videoPlayer.on('play', this.videoPlayer.requestFullscreen)
    }
  }

  disconnect () {
    this.videoPlayer.dispose()
  }
}
