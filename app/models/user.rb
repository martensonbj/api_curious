class User < ActiveRecord::Base

  def self.find_or_create_by_auth(auth)
    user = User.find_or_create_by(provider: auth['provider'], uid: auth['uid'])
    user.email = auth['info']['email']
    user.nickname = auth['info']['nickname']
    user.image = auth['info']['image']
    user.name = auth['info']['name']
    user.token = auth['credentials']['token']

    user.save
    user
  end
end
