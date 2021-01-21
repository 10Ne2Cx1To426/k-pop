class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: :show

  def index
    @users = User.all
    @match_users = current_user.matchers
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user.id)
    else
      render :edit
    end
  end

  def show
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    @favorites = Favorite.where(user_id: @user.id)
    @joins = Join.where(user_id: @user.id)
    @events = Event.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      unless @isRoom
      @room = Room.new
      @entry = Entry.new
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :lastname, :firstname, :birthday, :password, :password_confirmation, :email, :image)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
