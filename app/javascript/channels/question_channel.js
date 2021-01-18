import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  // Create QuestionChannel only  for /questions or root_path
  if (/questions/.test(window.location.pathname) || /^\/$/.test(window.location.pathname)) {
    const template = require('../templates/question.hbs')

    consumer.subscriptions.create("QuestionChannel", {
      received(data) {
        let result = template(data);
        let questions = document.getElementById('questions')
        if (questions) {
          questions.innerHTML += result
        }
      }
    });
  }
})
