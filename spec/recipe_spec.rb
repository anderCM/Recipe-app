require 'rails_helper'
require 'faker'

describe Recipe, type: :model do
  before do
    @user = User.new(
      name: Faker::Name.first_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )
    @name = Faker::Food.dish
    @preparation_time = Faker::Time.between(from: DateTime.now, to: DateTime.now + 7)
    @cooking_time = Faker::Time.between(from: DateTime.now, to: DateTime.now + 7)
    @description = Faker::Lorem.paragraph
    @public = Faker::Boolean.boolean
  end


  it 'is invalid without name' do
    recipe = Recipe.new(name: nil)
    recipe.valid?
    expect(recipe.errors[:name]).to include("can't be blank")
  end

  it 'is private by default' do
    recipe = Recipe.new(name: @name,
                        preparation_time: @preparation_time,
                        cooking_time: @cooking_time,
                        description: @description)
    recipe.valid?
    recipe.save
    expect(recipe.public).to eq(false)
  end

  it 'should belongs to User' do
    @user.save
    recipe = Recipe.new(name: @name,
                        preparation_time: @preparation_time,
                        cooking_time: @cooking_time,
                        description: @description,
                        user: @user)
    recipe.valid?
    recipe.save
    expect(recipe.user).to eq(@user)
  end
end
