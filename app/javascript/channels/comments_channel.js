import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  if (/questions\/\d+/.test(window.location.pathname)) {

    consumer.subscriptions.create({channel: "CommentsChannel"}, {

        received(data) {

          if (gon.current_user_id != data.comment.user_id) {
            var id = data.comment.commentable_type.toLowerCase() + '_' + data.comment.commentable_id + '_comments'
            const Handlebars = require("handlebars")

            var source = "<li id=\"comment_{{comment.id}}\"><div class='row small'>" +
              "<div class='col-10'> {{ comment.body }} </div> " +
              "<div class='col-2 text-right'>{{user}}</div></div></li>"

            var template = Handlebars.compile(source);
            var result = template(data);
            document.getElementById(id).innerHTML += result
          }
        }
      }
    );
  }
});
