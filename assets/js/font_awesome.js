import {config, dom, library} from '@fortawesome/fontawesome-svg-core'
import {
  faCheck,
  faCog,
  faEnvelope,
  faEye,
  faHome,
  faLock,
  faPencilAlt,
  faSignOutAlt,
  faTrash,
  faUser
} from '@fortawesome/free-solid-svg-icons'

config.keepOriginalSource = false
config.mutateApproach     = 'sync'

library.add(
  faCheck,
  faCog,
  faEnvelope,
  faEye,
  faHome,
  faLock,
  faPencilAlt,
  faSignOutAlt,
  faTrash,
  faUser
)

dom.watch()
