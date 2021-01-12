import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
// Create AnswerChannel only /questions/:id
  if (/questions\/\d+/.test(window.location.pathname)) {

    consumer.subscriptions.create({channel: "AnswerChannel", question_id: gon.question_id}, {

      received(data) {
        if (gon.current_user_id === data.answer.user_id) return;
        let template = require('./templates/answer.hbs')
        data.current_user = gon.current_user_id
        let result = template(data)
        document.getElementById('answers').innerHTML += result
      }
    });
  }
})
