document.addEventListener('turbolinks:load', function () {

  $('form.new-answer').on('ajax:success', function (e){

    let answer = e.detail[0];
    $('#answers').append('<p>' + answer.body + '</p>');
  })
    .on('ajax:error', function(e){
      let errors = e.detail[0];
      $.each(errors, function(index,value){
      document.querySelector('#errors_new').append('<p>' + value+ '</p>');

      })
    })






  let el = document.getElementById('answers')
  if (el) {
    el.addEventListener('click', setter);
  }

  function setter(e) {
    if (e.target.classList.contains('edit_link')) {
      editAnswer(e)
    }
    if (e.target.classList.contains('delete_link')) {
      deleteAnswer(e)
    }
  }

  function editAnswer(e) {
    const link = e.target;
    link.classList.add('hidden');
    const answerId = link.id
    document.getElementById('edit_form_' + answerId).classList.remove('hidden')
    e.preventDefault()
  }

  function deleteAnswer(e) {
    const link = e.target;
    const answerId = link.id;
    const answer = document.getElementById('answer_' + answerId);
    let parent = answer.parentNode;
    parent.removeChild(answer);
    e.preventDefault()
  }
})
