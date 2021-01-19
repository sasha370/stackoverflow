class Api::V1::AnswersController < Api::V1::BaseController
  # before_action :set_question, only: [:show, :destroy, :update]
  load_and_authorize_resource

  def index
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    render json: @answers,  each_serializer: AnswerCollectionSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end
end