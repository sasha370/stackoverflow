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

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @question.save
      render json: @answer
    else
      head 422
    end
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update(answer_params)
      render json: @answer
    else
      head 422
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    head :ok
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
