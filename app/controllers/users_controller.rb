class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :show

  def index
    @users = User.all
    @match_users = current_user.matchers
  end

  def show
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
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
