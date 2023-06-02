require 'rails_helper'
require 'faker'

RSpec.describe 'Recipe', type: :request do
  describe 'GET #index' do
    before do
      @user = User.create(
        name: Faker::Name.first_name,
        email: Faker::Internet.email,
        password: Faker::Internet.password
      )

      sign_in @user

      @recipe = Recipe.create(name: Faker::Food.dish,
                              preparation_time: Faker::Time.between(from: DateTime.now,
                                                                    to: DateTime.now + 7),
                              cooking_time: Faker::Time.between(from: DateTime.now,
                                                                to: DateTime.now + 7),
                              description: Faker::Lorem.paragraph,
                              public: Faker::Boolean.boolean,
                              user: @user)

      get recipes_path
    end

    it 'Should return successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'Should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'Should include Default text on template' do
      expect(response.body).to include('List of recipes')
    end

    it 'Should include new recipe' do
      expect(assigns(:recipes)).to match_array([@recipe])
    end

    it 'Should accept params, increase recipes counter and redirect' do
      recipe_params = {
        name: 'soupe al onion',
        preparation_time: 30,
        cooking_time: 45,
        description: 'Lorem ipsum dolor sit amet',
        public: true
      }
      expect { post recipes_path, params: { recipe: recipe_params } }.to change(Recipe, :count)
      expect(response).to redirect_to(recipes_path)
    end

    it 'Should accept params, increase RecipeFood counter and redirect' do
      food_params = {
        name: 'soupe al onion',
        measurement_unit: 'kgs',
        price: 1,
        quantity: 1
      }

      expect { post add_ingredient_recipe_path(@recipe), params: { food: food_params } }.to change(RecipeFood, :count)
      expect(response).to redirect_to(recipe_path(@recipe))
    end

    it 'should display food inside recipe' do
      food = Food.create(name: Faker::Food.unique.ingredient,
                    measurement_unit: Faker::Food.measurement,
                    price: Faker::Number.decimal(l_digits: 2),
                    quantity: Faker::Number.between(from: 1, to: 10),
                    user: @user)

      food2 = Food.create(name: Faker::Food.unique.ingredient,
                    measurement_unit: Faker::Food.measurement,
                    price: Faker::Number.decimal(l_digits: 2),
                    quantity: Faker::Number.between(from: 1, to: 10),
                    user: @user)
      RecipeFood.create(recipe: @recipe, food: , quantity: 1)
      RecipeFood.create(recipe: @recipe, food: food2, quantity: 1)

      get recipe_path(@recipe)
      expect(assigns(:recipe_foods)).to match_array([recipe_food1, recipe_food2])
    end
  end
end
