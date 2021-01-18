class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    authorize! :read, Question
    @questions = Question.all
    render json: @questions
    # each_serializer:
  end
  
end
