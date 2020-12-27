document.addEventListener('turbolinks:load', function () {

  let ratingLinks = document.querySelectorAll('.rating-link');

    //listening all links with ajax
  ratingLinks.forEach((link) => {

    link.addEventListener('ajax:success', (e) => {
      let data = e.detail[0]
      let rating_field = 'rating_' + data.type
      document.getElementById(rating_field).innerText = data.rating;

      // find thumb`s links and toggle it
      let  ratingLinks = 'rating_buttons_' +  data.type
      document.getElementsByClassName(ratingLinks)[0].classList.toggle('hidden');

      // find cancel_vote link and toggle it
      let  cancelLink = 'cancel_rating_' +  data.type
      document.getElementsByClassName(cancelLink)[0].classList.toggle('hidden');
    })
  })
})
