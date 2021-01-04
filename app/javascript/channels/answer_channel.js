import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  consumer.subscriptions.create({channel: "AnswerChannel", question_id: gon.question_id}, {
    connected() {
      console.log("Ответы в сети")
      // Called when the subscription is ready for use on the server
    },

    received(data) {
      console.log(data)
      if (gon.current_user_id != data.answer.user_id) {
        $('#answers').append(data.html);
      }
    }
  });
});
