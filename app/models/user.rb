class User < ApplicationRecord
  validates :uid, :username, :provider, presence: true
  # rubocop:disable Rails/Validation
  validates_uniqueness_of [:uid, :username], uniqueness: { case_sensitive: false }
  # rubocop:enable Rails/Validation

  def self.create_from_omniauth(auth)
    User.find_or_create_by!(uid: auth['uid'], provider: auth['provider']) do |user|
      user.username = auth['info']['name']
    end
  end
end
