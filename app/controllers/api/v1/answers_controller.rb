class API::V1::AnswersController < API::V1::BaseController
  before_action :find_question, only: [:index, :create]
  before_action :set_answer, only: [:destroy, :show, :update]
  load_and_authorize_resource

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @question.save
      render json: @answer
    else
      head 422
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      head 422
    end
  end

  def destroy
    @answer.destroy
    head :ok
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
