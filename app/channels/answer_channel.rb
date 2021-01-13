class AnswerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_question_#{params[:question_id]}"
  end

  def unsubscribed
  end
end
