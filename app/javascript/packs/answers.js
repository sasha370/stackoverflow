document.addEventListener('turbolinks:load', function () {
  document.getElementById('answers').addEventListener('click', setter);

  function setter (e){
    if (e.target.classList.contains('edit_link')) {
      editAnswer(e)
    }
    if (e.target.classList.contains('delete_link')) {
      deleteAnswer(e)
    }
  }

  function editAnswer(e) {
    // if (e.target.classList.contains('edit_link')) {
      const link = e.target;
      link.classList.add('hidden');
      const answerId = link.id
      document.getElementById('edit_form_' + answerId).classList.remove('hidden')
      e.preventDefault()
    // }
  }

  function deleteAnswer(e){
    const link = e.target;
    const answerId = link.id;
    const answer = document.getElementById('answer_' + answerId);
    let  parent = answer.parentNode;
    parent.removeChild(answer);
    e.preventDefault()
  }


})
