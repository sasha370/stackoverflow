class AnswersController < ApplicationController
  include Ratinged
  include Commented

  before_action :authenticate_user!, only: [:create, :destroy, :update, :choose_best]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :destroy, :choose_best]
  after_action :publish_answer, only: [:create]

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.js { flash[:notice] = 'Your answer successfully created.' }
      else
        format.js { flash[:alert] = 'Your have an errors!' }
      end
    end
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def choose_best
    @answer.set_best if current_user.author?(@answer.question)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("answers_question_#{@answer.question_id}",
                                 answer: @answer,
                                 html: html(@answer)
    )
  end

  def html(answer)
    wardenize
    @job_renderer.render(
        partial: 'answers/answer',
        locals: { answer: answer }
    )
  end

  def wardenize
    @job_renderer = ::AnswersController.renderer.new
    renderer_env = @job_renderer.instance_eval { @env }
    warden = ::Warden::Proxy.new(renderer_env, ::Warden::Manager.new(Rails.application))
    renderer_env['warden'] = warden
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :done, :_destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
