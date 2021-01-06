import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  // Create AnswerChannel only /questions/:id
  if (/questions\/\d+/.test(window.location.pathname)) {

    consumer.subscriptions.create({channel: "AnswerChannel", question_id: gon.question_id}, {

      received(data) {
        if (gon.current_user_id != data.answer.user_id) {
          $('#answers').append(data.html);
        }
      }
    });

    // Create QuestionChannel only  for /questions or root_path
  } else if (/questions/.test(window.location.pathname) || /^\/$/.test(window.location.pathname) )  {
    consumer.subscriptions.create("QuestionChannel", {

      received(content) {
        const Handlebars = require("handlebars");
        var source = "<div class='row'><div class='col-1 small'>Rating: 0</div>" +
          "<div class='col-11'>" + "<a title='{{title}}' href='{{url}}'>{{title}}</a></div></div><hr/>"
        var template = Handlebars.compile(source);
        var data = content.content
        var result = template(data);
        document.getElementById('questions').innerHTML += result
      }
    });
  }
})
