class User < ApplicationRecord
  validates :uid, :username, :provider, presence: true
  validates_uniqueness_of [:uid, :provider, :username], uniqueness: { case_sensitive: false }

  def self.create_from_omniauth(auth)
    User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |user|
      user.username = auth['info']['name']
    end
  end
end
