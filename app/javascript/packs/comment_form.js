document.addEventListener('turbolinks:load', function () {
  let commentButtons = document.querySelectorAll('.add_commit_btn');

  if (commentButtons) {
    commentButtons.forEach((btn) => {
      btn.addEventListener('click', removeBtn)
    })
  }

  function removeBtn(e) {
    e.target.nextElementSibling.classList.remove('hidden')
    e.target.classList.add('hidden')
    e.preventDefault()
  }
})
