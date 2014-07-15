class Waiter < ActiveRecord::Base
  # Try to start game ... if no enough free players (3) then just 
  # put player in queue
  def self.try_to_create(user) 
    a = Waiter.lock.all
    g = nil
    if a.size < 2 
      w = Waiter.new
      w.user_id = user.id
      w.save!
    else
      players = [user.id] 
      2.times do |t|
        players << a[t].user_id
        Waiter.destroy(a[t].id)
      end
      g = Game.create_game(players.shuffle)
    end
    g 
  end
  def self.are_waiting?(user) 
    Waiter.find_by(user_id: user.id) != nil
  end
end
