class WaitersController < ApplicationController
  def index
    @show_login = true
    @show_title = true
    @waiters = Waiter.all
  end
  def create
    Waiter.try_to_create(current_user)
    redirect_to :root
  end
end
