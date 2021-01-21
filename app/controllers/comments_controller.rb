class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to event_path(@comment.event)
    else
      @event = @event.prototype
      @comments = @event.comments
      render "events/show"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, event_id: params[:event_id])
  end
end
