module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :setup_resource, only: [:add_comment]
    after_action :publish_comment, only: [:add_comment]
  end

  def add_comment
    @comment = @commented.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.js do
          render partial: 'comments/add_comment', layout: false
        end
      end
    end
  end

  def destroy_comment
    @comment = Comment.find(params[:comment_id])
    if current_user.author?(@comment)
      render partial: 'comments/destroy_comment', layout: false
      @comment.destroy
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def setup_resource
    @commented = model_klass.find(params[:id])
  end

  def publish_comment
    return if @commented.errors.any?
    ActionCable.server.broadcast(
        'comments',
        comment: @comment,
        user: current_user.email
    )
  end
end
