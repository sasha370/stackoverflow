class AnswersController < ApplicationController
  before_action :authenticate_user!,only: [:create, :destroy]
  before_action :set_question, only: [:create, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:alert] = 'Your answer have an errors!'
    end
    redirect_to question_path(@question)
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user == @answer.question.user
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted.'
    else
      flash[:alert] = 'Your have`n permission for this action'
    end
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
