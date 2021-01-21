class GroupsController < ApplicationController
  before_action :authenticate_user!
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params_group)
    tag_list = params[:group][:tag_name].split(",")
    if @group.save
      @group.save_groups(tag_list)
      redirect_to groups_path
    else
      render :new
    end
  end

  private

  def params_group
    params.require(:group).permit(:name, :text, :image).merge(user_id: current_user.id)
  end
end
