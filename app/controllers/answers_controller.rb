class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @question
    else
      set_question # т.к. в question хранятся данные о несохраненном ответе c id = nil, его надо обновить из БД
      flash.now[:alert] = 'Your answer have an errors!'
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user_id
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted.'
      redirect_to @question
    else
      flash.now[:alert] = 'Your have`n permission for this action'
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
