import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

    // Create QuestionChannel only  for /questions or root_path
    if (/questions/.test(window.location.pathname) || /^\/$/.test(window.location.pathname)) {
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
