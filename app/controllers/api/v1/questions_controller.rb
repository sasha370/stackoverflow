class API::V1::QuestionsController < API::V1::BaseController
  before_action :set_question, only: [:show, :destroy, :update]
  load_and_authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question
    else
      head 422
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      head 422
    end
  end

  def destroy
    @question.destroy
    head :ok
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
