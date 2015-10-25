class User < ActiveRecord::Base

  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy

  #From Paperclip docs
  has_attached_file :avatar,
                    :storage => :s3,  #for Amazon S3
                    :style => { :medium => "370x370", :thumb => "100x100" }

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  default_scope { order('id DESC') }

  #either find user or create a new user
  def self.sign_in_from_facebook(auth)
    find_by( provider: auth['provider'], uid: auth['uid'] ) || create_user_from_facebook(auth)
  end

  #Hash from https://github.com/mkdynamic/omniauth-facebook
  def self.create_user_from_facebook(auth)
    create(
      avatar: process_uri(auth['info']['image'] + "?width=9999"),
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

  #Friendship Methods
  def request_match(other_user)
    self.friendships.create(friend: other_user)
  end

  def accept_match(other_user)
    self.friendships.where(friend: other_user).first.update_attribute(:state, "active")
  end

  def remove_match(other_user)
    inverse_friendship = inverse_friendships.where(user_id: other_user).first

    if inverse_friendship
      self.inverse_friendships.where(user_id: other_user).first.destroy
    else
      self.friendships.where(friend_id: other_user).first.destroy
    end

  end

  private
  def self.process_uri(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end

end
