require 'rails_helper'
require 'faker'

RSpec.describe 'Recipe Food', type: :request do
  describe 'GET #index' do
    before do
      @user = User.create(
        name: Faker::Name.first_name,
        email: Faker::Internet.email,
        password: Faker::Internet.password
      )

      @new_recipe = Recipe.create(name: Faker::Food.dish,
                                  preparation_time: Faker::Time.between(from: DateTime.now,
                                                                        to: DateTime.now + 7),
                                  cooking_time: Faker::Time.between(from: DateTime.now,
                                                                    to: DateTime.now + 7),
                                  description: Faker::Lorem.paragraph,
                                  public: true,
                                  user: @user)

      get public_recipes_path
    end

    it 'Should return successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'Should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'Should include Default text on template' do
      expect(response.body).to include('Public Recipes')
    end

    it 'Should include new recipe' do
      expect(assigns(:recipe_names)).to include(@new_recipe)
    end
  end
end
