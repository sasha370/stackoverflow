class QuestionsController < ApplicationController
  include Ratinged
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy, :subscribe]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
    @answer.links.new
    set_gon
    @comment = Comment.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted.'
  end

  def subscribe
    @subscription = @question.subscriptions.find_by(user: current_user)
    if @subscription
      @subscription.destroy
      flash.now[:alert] = 'You were Unsubscribed from this question'
    else
      @question.subscriptions.create(user: current_user)
      flash.now[:notice] = 'You were subscribed to this question'
    end
  end

  private

  def set_gon
    gon.question_id = @question.id
    gon.current_user_id = current_user&.id
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        question: @question,
        author: @question.user.email
    )
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :done, :_destroy], reward_attributes: [:id, :title, :image])
  end

end
