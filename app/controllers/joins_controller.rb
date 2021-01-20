class JoinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_user
  
  def index
  end

  def create
    @join = Join.new(join_params)
    if @join.save
      redirect_to event_path(@event)
    else
      render :index
    end
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end

  def join_params
    params.permit(:event_id).merge(user_id: current_user.id)
  end

  def check_user
    if @event.user_id == current_user.id
      redirect_to root_path
    end
  end
end
