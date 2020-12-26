document.addEventListener('turbolinks:load', function () {

  let ratingLinks = document.querySelectorAll('.rating-link');
  ratingLinks.forEach((link) => {
    link.addEventListener('ajax:success', (e) => {
      let data = e.detail[0]
      let rating_field = 'rating_' + data.type + '_' + data.id
      document.getElementById(rating_field).innerText = data.rating
    })
  })
})
