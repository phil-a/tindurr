class User < ActiveRecord::Base

  #either find user or create a new user
  def self.sign_in_from_facebook(auth)
    find_by( provider: auth['provider'], uid: auth['uid'] ) || create_user_from_facebook(auth)
  end

  #Hash from https://github.com/mkdynamic/omniauth-facebook
  def self.create_user_from_facebook(auth)
    create(

      email: auth['info']['email'],
      provider: auth['provider'],
      uid: auth['uid'],
      name: auth['info']['name'],
      gender: auth['extra']['raw_info']['gender'],
      date_of_birth: auth['extra']['raw_info']['birthday'],
      location: auth['info']['location'],
      bio: auth['extra']['raw_info']['bio']

      )
  end

end
