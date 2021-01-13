import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  // Create QuestionChannel only  for /questions or root_path
  if (/questions/.test(window.location.pathname) || /^\/$/.test(window.location.pathname)) {
    const template = require('../templates/question.hbs')

    consumer.subscriptions.create("QuestionChannel", {
      received(data) {
        var result = template(data);
        document.getElementById('questions').innerHTML += result
      }
    });
  }
})
