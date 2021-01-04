import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  consumer.subscriptions.create("QuestionChannel", {

    received(content) {
      const Handlebars = require("handlebars");
      var source = "<div class='row'><div class='col-1 small'>Rating: 0</div><div class='col-11'>" + "<a title='{{title}}' href='{{url}}'>{{title}}</a>" + " </div> </div>"
      var template = Handlebars.compile(source);
      var data = content.content
      var result = template(data);
      document.getElementById('questions').innerHTML += result
    }
  });
})
