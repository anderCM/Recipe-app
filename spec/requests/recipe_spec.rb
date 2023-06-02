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

    it 'Should accept params and increase recipes counter' do
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
  end
end
