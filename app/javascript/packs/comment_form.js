document.addEventListener('turbolinks:load', function () {

  let el = document.getElementById('answers')

  if (el) {
    el.addEventListener('click', setter);
    }

  function setter(e){
    if (e.target.classList.contains('add_commit_btn')) {
      removeBtn(e)
    }}

    function removeBtn(e) {
      e.target.nextElementSibling.classList.remove('hidden')
      e.target.classList.add('hidden')
      e.preventDefault()
    }
})
