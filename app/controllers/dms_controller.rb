class DmsController < ApplicationController
  before_action :authenticate_user!
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:dm][:room_id]).present?
      @dm = Dm.create(params_direct_message)
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
    end
    redirect_to room_path(@dm.room_id)
  end

  private

  def params_direct_message
    params.require(:dm).permit(:user_id, :message, :room_id, :image).merge(user_id: current_user.id)
  end
end
