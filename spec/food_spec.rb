require 'rails_helper'
require 'faker'

describe Food, type: :model do
  before do
    @user = User.create!(
      name: Faker::Name.first_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )

    @name = Faker::Food.unique.ingredient
    @measurement_unit = Faker::Food.measurement
    @price = Faker::Number.decimal(l_digits: 2)
    @quantity = Faker::Number.between(from: 1, to: 10)
  end

  it 'Is invalid without name' do
    food = Food.new(name: nil)
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it 'Is invalid without measurement unit' do
    food = Food.new(name: @name, measurement_unit: nil)
    food.valid?
    expect(food.errors[:measurement_unit]).to include("can't be blank")
  end

  it 'Price should be integer' do
    food = Food.new(name: @name, measurement_unit: @measurement_unit, price: Faker::Name.first_name)
    food.valid?
    expect(food.errors[:price]).to include('is not a number')
  end

  it 'Quantity should be greater than 0' do
    food = Food.new(name: @name,
                    measurement_unit: @measurement_unit,
                    price: @price,
                    quantity: -1)
    food.valid?
    expect(food.errors[:quantity]).to include('must be greater than or equal to 1')
  end

  it 'Is invalid without User' do
    food = Food.new(name: @name,
                    measurement_unit: @measurement_unit,
                    price: @price,
                    quantity: @quantity,
                    user: nil)
    food.valid?
    food.save
    expect(food.errors[:user]).to include('must exist')
  end

  it 'Should belongs to User' do
    @user.save
    food = Food.new(name: @name,
                    measurement_unit: @measurement_unit,
                    price: @price,
                    quantity: @quantity,
                    user: @user)
    food.valid?
    food.save
    expect(food.user).to eq(@user)
  end
end
