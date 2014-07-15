class WaitersController < ApplicationController
  def index
    @show_login = true
    @show_title = true
    @waiters = Waiter.all
  end
  def create
    g = Waiter.try_to_create(current_user)
    if g == nil 
      redirect_to :root
    else
      redirect_to game_path(g)
    end
  end
end
