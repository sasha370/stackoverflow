import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  // Create AnswerChannel only /questions/:id
  if (/questions\/\d+/.test(window.location.pathname)) {

    consumer.subscriptions.create({channel: "AnswerChannel", question_id: gon.question_id}, {
      connected() {
        console.log("Ответы в сети")
      },

      received(data) {
        console.log(data)
        if (gon.current_user_id != data.answer.user_id) {
          $('#answers').append(data.html);
        }
      }
    });

  } else if (/questions/.test(window.location.pathname) || /^\/$/.test(window.location.pathname) )  {
    // Create QuestionChannel only /questions OR root_path

    consumer.subscriptions.create("QuestionChannel", {
      connected() {
        console.log("ВОПРОСЫ  в сети")
      },

      received(content) {
        const Handlebars = require("handlebars");
        var source = "<div class='row'><div class='col-1 small'>Rating: 0</div><div class='col-11'>" + "<a title='{{title}}' href='{{url}}'>{{title}}</a>" + " </div> </div>"
        var template = Handlebars.compile(source);
        var data = content.content
        var result = template(data);
        document.getElementById('questions').innerHTML += result
      }
    });
  }
})
