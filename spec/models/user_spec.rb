require 'rails_helper'



RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :uid}
    it {should validate_presence_of :username}
    it {should validate_presence_of :provider}
    it {should validate_uniqueness_of :uid}
    it {should validate_uniqueness_of :username}
  end
  # describe 'class methods' do
  #   describe '::find_or_create_by' do
  #     it 'responds to finding a user who logs in through omniauth or creates a user if user does not exist' do
  #     end
  #   end
  # end
end
