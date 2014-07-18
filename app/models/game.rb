class Game < ActiveRecord::Base
  def self.delete_game(id)
    Speech.delete_all(game_id: id) 
    Round.delete_all(game_id: id)
    Game.delete_all(id: id)
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
  
  def end_game
    cg = ClosedGame.new
    cg.game_id = self.id
    cg.left = self.left
    cg.right = self.right
    cg.scoreright = self.scoreright
    cg.scoreleft = self.scoreleft
    cg.save!
    
    leftstat = UserStat.where(user_id: left).first() 
    judgestat = UserStat.where(user_id: judge).first() 
    rightstat = UserStat.where(user_id: right).first() 
    
    
    if self.scoreright > self.scoreleft 
      rightstat.games_won = rightstat.games_won + 1
    else  
      leftstat.games_won = leftstat.games_won + 1
    end
    
    leftstat.games_played = leftstat.games_played + 1
    rightstat.games_played = rightstat.games_played + 1
    judgestat.games_judged = judgestat.games_judged + 1
    
    leftstat.save!
    rightstat.save!
    judgestat.save!
    Game.delete_game(self.id)
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
    r = rb / 2 + 1
    Round.where(game_id: id, round_num: r).first()
  end
  def current_task 
    Round.where(game_id: id, round_num: self.round).first().task
  end
  def judge_round(who,task) 
    puts "Judge choose #{who}"
    if who == left
      self.scoreleft = self.scoreleft + 1
     else
      self.scoreright = self.scoreright + 1
    end
    if self.round == 5 
      end_game
      return true
    else
      next_on_move
      self.round = round + 1
      r = Round.new 
      r.game_id = id
      r.round_num = self.round
      r.task = task
      r.save!
      save!
      return false
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
