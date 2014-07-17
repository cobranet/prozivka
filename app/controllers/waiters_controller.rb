class WaitersController < ApplicationController
  def index
    @show_login = true
    @show_title = true
    @show_gametitle = false
    @waiters = Waiter.all
  end
  def create
    g = Waiter.try_to_create(current_user)
    if g == nil 
      redirect_to :root
    else
      atr = { action: 'startgame' ,
             gameid: g.id } 
      FayeRails::Controller.publish("/chat#{g.left}" ,atr)        
      FayeRails::Controller.publish("/chat#{g.right}" ,atr)        
      FayeRails::Controller.publish("/chat#{g.judge}" ,atr)        
      redirect_to game_path(g)
    end
  end
end
