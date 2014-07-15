class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
    @show_title = true
    @show_login = false
  end
end
