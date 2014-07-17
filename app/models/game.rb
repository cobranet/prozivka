class Game < ActiveRecord::Base
  def self.restart_game(id)
    Speech.delete_all(game_id: id) 
    Round.delete_all(game_id: id);
    g = Game.find(id) 
    g.round = 0
    g.onmove = g.judge
    g.scoreright = 0
    g.scoreleft = 0
    g.save!
  end

  def self.create_game(arr)
    g = Game.new
    g.left = arr[0]
    g.right = arr[1] 
    g.judge = arr[2]
    g.onmove = g.judge
    g.round = 0
    g.scoreleft = 0
    g.scoreright = 0
    g.save!
    g
  end
  
  def rounds
    Round.where(game_id: id)
  end
  def next_on_move
    if onmove == judge 
      if [0,2,4].include?(round)
        self.onmove = left
      else
        self.onmove = right
      end
      return
    end
    if speeches.size % 2 == 0
       self.onmove = judge
       return
    end
    if self.onmove == right
      self.onmove = left
    else
      self.onmove = right
    end
  end
  def round_for_rb(rb) 
    r = (rb+1) / 2 
    Round.where(game_id: id, round_num: r).first()
  end
  def judge_round(who,task) 
    puts "Judge choose #{who}"
    if who == left
      self.scoreleft = self.scoreleft + 1
     else
      self.scoreright = self.scoreright + 1
    end
    next_on_move
    self.round = round + 1
    r = Rounds.new 
    r.game_id = id
    r.round_num = self.round
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
  
  def startround(task)
    r = Round.new
    r.game_id = id
    r.round_num = round + 1
    r.task = task
    r.save!
    self.round = round + 1
    next_on_move
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
