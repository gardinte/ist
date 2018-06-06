document.addEventListener('click', event => {
  const burger = event.target.closest('.navbar-burger')

  if (burger) {
    const target = document.querySelector(burger.dataset.target)

    burger.classList.toggle('is-active')
    target.classList.toggle('is-active')
  }
})
