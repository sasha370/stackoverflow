import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  // Create QuestionChannel only  for /questions or root_path
  if (/questions/.test(window.location.pathname) || /^\/$/.test(window.location.pathname)) {
    consumer.subscriptions.create("QuestionChannel", {

      received(data) {
        let template = require('./templates/question.hbs')
        var result = template(data);
        document.getElementById('questions').innerHTML += result
      }
    });
  }
})
