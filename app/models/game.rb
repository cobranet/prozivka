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
  
  def next_on_move
    if onmove == left
      self.onmove = right
    elsif onmove == right
      self.onmove = left
    else
      self.onmove = judge
    end
  end

  def left_user 
    User.find(left)
  end
  
  def right_user
    User.find(right) 
  end
  
 
  def judge_user
    User.find(judge)
  end
  def last_five 
    a = Speech.where(game_id: id).limit(5).order('rb desc')
    b = a.to_a
    b.sort!{ |x,y| x.rb <=> y.rb }
    b
  end
  def speeches 
    a  = Speech.where(game_id: id).order(:rb)
  end
  
  def add_speech(user_id,speech) 
    rb = speeches.size
    s = Speech.new
    s.user_id = user_id
    s.speech = speech 
    s.game_id = id
    s.rb = rb
    s.save!
  end
  
  def user_on_move
    User.find(onmove)
  end
end
