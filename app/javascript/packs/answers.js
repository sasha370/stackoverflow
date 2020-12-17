document.addEventListener('turbolinks:load', function () {
  document.getElementById('answers').addEventListener('click', editAnswer);
  function editAnswer(e) {
    if (e.target.classList.contains('edit_link')) {
      const link = e.target;
      link.classList.add('hidden');
      const answerId = link.id
      document.getElementById('edit_form_' + answerId).classList.remove('hidden')
      e.preventDefault()
    }
  }

})
