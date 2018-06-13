import fontawesome  from '@fortawesome/fontawesome'

import faCheck      from '@fortawesome/fontawesome-free-solid/faCheck'
import faCog        from '@fortawesome/fontawesome-free-solid/faCog'
import faEnvelope   from '@fortawesome/fontawesome-free-solid/faEnvelope'
import faEye        from '@fortawesome/fontawesome-free-solid/faEye'
import faHome       from '@fortawesome/fontawesome-free-solid/faHome'
import faLock       from '@fortawesome/fontawesome-free-solid/faLock'
import faPencilAlt  from '@fortawesome/fontawesome-free-solid/faPencilAlt'
import faSignOutAlt from '@fortawesome/fontawesome-free-solid/faSignOutAlt'
import faTrash      from '@fortawesome/fontawesome-free-solid/faTrash'
import faUser       from '@fortawesome/fontawesome-free-solid/faUser'

fontawesome.config = {
  keepOriginalSource: false
}

fontawesome.library.add([
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
])

// Needed only because mutation observer on FA watch for body changes
// and Turbolinks replaces it
document.addEventListener('turbolinks:load', fontawesome.dom.i2svg)
