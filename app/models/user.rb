class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.image = auth.info.image
      user.location = auth.info.location
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
      if UserStat.where(user_id: user.id).first() == nil 
        us = UserStat.new
        us.user_id = user.id
        us.games_won = 0
        us.games_played  = 0
        us.games_judged = 0
        us.save!
      end  
    end
  end
  
  def waiting?
    not Waitingplayer.find_by( user_id: id ) == nil
  end
  def self.get_user(id)
    User.find(id)
  end
  def self.get_user_image(id)
    User.find(id).image
  end
end
