class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
    @show_title = false
    @show_gametitle = true
    @show_login = true
  end
  
  def last_five
    @game = Game.find(params[:id])
    @last_five == true    
    render :layout => false
  end
  
  def startround
    @game = Game.find(params[:id]) 
    @game.startround(params[:task])
    @game.save!
    atr = {
      action: 'startround'
      }
    FayeRails::Controller.publish(all_chanel(@game.id),atr)        
    render :nothing => true
  end
  
  def judge
    @game = Game.find(params[:id]) 
    @game.judge_round(params[:who].to_i,params[:task])
    @game.save!
    atr = {
      action: 'judged'
    }
    FayeRails::Controller.publish(all_chanel(@game.id),atr)        
    render :nothing => true
  end
  
  def gametitle 
    @game = Game.find(params[:id])
    render :layout => false
  end
  def actions
    @game = Game.find(params[:id])
    render :layout => false
  end

  def all_chanel(id)
    "/allplayers#{id}"
  end
  
  def make_speech
    @game = Game.find(params[:id]) 
    @game.add_speech(current_user.id,params[:speech])
    @game.next_on_move
    @game.save!
    atr = { 
      action: 'newspeech',
      onmove: @game.onmove
    } 
    FayeRails::Controller.publish(all_chanel(@game.id),atr)    
    render :nothing => true
  end
end
