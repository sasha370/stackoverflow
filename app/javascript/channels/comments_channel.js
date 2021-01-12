import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  if (/questions\/\d+/.test(window.location.pathname)) {

    consumer.subscriptions.create({channel: "CommentsChannel"}, {

        received(data) {

          if (gon.current_user_id != data.comment.user_id) {
            let id = data.comment.commentable_type.toLowerCase() + '_' + data.comment.commentable_id + '_comments'

            let template = require('./templates/comment.hbs')
            let result = template(data)
            document.getElementById(id).innerHTML += result
          }
        }
      }
    );
  }
});
