class Game < ActiveRecord::Base
  def self.create_game(arr)
    g = Game.new
    g.left = arr[0]
    g.right = arr[1] 
    g.judge = arr[2]
    g.onmove = g.left
    g.save!
    g
  end
  def left_user 
    User.find(left)
  end
  def righ_user
    User.find(right) 
  end
  def judge_user
    User.find(judge)
  end
end
