import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

    // Create QuestionChannel only  for /questions or root_path
    if (/questions/.test(window.location.pathname) || /^\/$/.test(window.location.pathname)) {
        consumer.subscriptions.create("QuestionChannel", {

            received(content) {
                let template = require('./templates/question.hbs')
                var data = content.content
                var result = template(data);
                document.getElementById('questions').innerHTML += result
            }
        });
    }
})
