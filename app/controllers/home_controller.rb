class HomeController < ApplicationController
  def index
    @events = Event.order(created_at: :DESC).limit(9)
    @groups = Group.order(created_at: :DESC).limit(3)
  end
end
