require 'rails_helper'
require 'faker'

describe User, type: :model do
  before do
    @fake_name = Faker::Name.first_name
    @fake_email = Faker::Internet.email
  end
  it 'Is invalid without name' do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'Is invalid without an email' do
    user = User.new(name: @fake_name, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'Password should have at least 6 characters' do
    user = User.new(name: @fake_name, email: @fake_email, password: '123')
    user.valid?
    expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
  end
end
