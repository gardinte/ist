document.addEventListener('click', event => {
  const element  = event.target
  const selector = element.dataset['delete']
  const parent   = selector && element.closest && element.closest(selector)

  parent && parent.remove()
})
