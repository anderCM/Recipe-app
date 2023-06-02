require 'rails_helper'
require 'faker'

describe Recipe, type: :model do
  before do
    @user = User.create(
      name: Faker::Name.first_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )
    @recipe = Recipe.create(name: Faker::Food.dish,
                            preparation_time: Faker::Time.between(from: DateTime.now,
                                                                  to: DateTime.now + 7),
                            cooking_time: Faker::Time.between(from: DateTime.now,
                                                              to: DateTime.now + 7),
                            description: Faker::Lorem.paragraph,
                            public: Faker::Boolean.boolean,
                            user: @user)

    @food = Food.create(name: Faker::Food.unique.ingredient,
                        measurement_unit: Faker::Food.measurement,
                        price: Faker::Number.decimal(l_digits: 2),
                        quantity: Faker::Number.between(from: 1, to: 10),
                        user: @user)
  end

  it 'is invalid without recipe' do
    recipe_food = RecipeFood.new(recipe: nil, food: @food, quantity: 12)
    recipe_food.valid?
    expect(recipe_food.errors[:recipe]).to include('must exist')
  end

  it 'is invalid without recipe' do
    recipe_food = RecipeFood.new(recipe: @recipe, food: nil, quantity: 12)
    recipe_food.valid?
    expect(recipe_food.errors[:food]).to include('must exist')
  end

  it 'is invalid without quantity' do
    recipe_food = RecipeFood.new(recipe: @recipe, food: @food, quantity: nil)
    recipe_food.valid?
    expect(recipe_food.errors[:quantity]).to include("can't be blank")
  end

  it 'quantity must be a number' do
    recipe_food = RecipeFood.new(recipe: @recipe, food: @food, quantity: 'five')
    recipe_food.valid?
    expect(recipe_food.errors[:quantity]).to include('is not a number')
  end

  it 'quantity must be greater than 0' do
    recipe_food = RecipeFood.new(recipe: @recipe, food: @food, quantity: 0)
    recipe_food.valid?
    expect(recipe_food.errors[:quantity]).to include('must be greater than or equal to 1')
  end
end
