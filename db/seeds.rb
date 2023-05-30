# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'
6.times do
user = User.create!(
  name: Faker::Name.first_name,
  email: Faker::Internet.email,
  password: Faker::Internet.password)
end

  User.all.each do |user|
    5.times do
      food = Food.create!(
        name: Faker::Food.unique.ingredient, 
        measurement_unit: Faker::Food.measurement,
        price: Faker::Number.decimal(l_digits: 2),
        quantity: Faker::Number.between(from: 1, to: 10),
        user: user
      )
    recipe = Recipe.create(
      name: Faker::Food.dish,
      preparation_time: Faker::Time.between(from: DateTime.now, to: DateTime.now + 7),
      cooking_time: Faker::Time.between(from: DateTime.now, to: DateTime.now + 7),
      description: Faker::Lorem.paragraph,
      public: Faker::Boolean.boolean,
      user: user
    )
    foods = Food.limit(5)
    foods.each do |food|
        recipe.recipe_foods.create(food: food, quantity: Faker::Number.between(from: 1, to: 5))
    end
  end
end
