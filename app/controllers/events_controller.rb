class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:edit, :update, :destroy, :show]
  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    #@events = Event.all
    if params[:tag_id]
      @tag_list = Tag.all
      @tag = Tag.find(params[:tag_id])
      @events = @tag.events
    else
      @tag_list = Tag.all
      @events = Event.includes(:user)
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    tag_list = params[:event][:tag_name].gsub(" ", "").split(",")
      if @event.save
        @event.save_events(tag_list)
        redirect_to events_path
      else
        render :new
      end
  end

  def edit
    @tag_list = @event.tags.pluck(:tag_name).join(",")
  end

  def update
    tag_list = params[:event][:tag_name].split(",")
    if @event.update(event_params)
      @event.save_events(tag_list)
      redirect_to event_path(@event)
    else
      render :edit
    end
  end

  def show
    @join = Join.where(event_id: @event.id)
    @comment = Comment.new
    @comments = @event.comments.includes(:user)
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :text, :date, :prefecture_id, :start_time, :finish_time, :postal_code, :city, :house_number, :building, :tag_name, :image, :member).merge(user_id: current_user.id)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def check_user
    if current_user.id != @event.user_id
      redirect_to root_path
    end
  end
end
