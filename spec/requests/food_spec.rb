require 'rails_helper'
require 'faker'

RSpec.describe 'Food', type: :request do
  describe 'GET #index' do
  let!(:food2) { Food.create(name: 'Food Name', measurement_unit: 'kg', price: 200, quantity: 2, user: @user) }
    before do
      @user = User.create(
        name: Faker::Name.first_name,
        email: Faker::Internet.email,
        password: Faker::Internet.password
      )

      sign_in @user

      @name = Faker::Food.unique.ingredient
      @measurement_unit = Faker::Food.measurement
      @price = Faker::Number.number(digits: 10)
      @quantity = Faker::Number.between(from: 1, to: 10)

      @food = Food.create(name:@name,measurement_unit:@measurement_unit, price:@price,quantity:@quantity, user:@user)

        # puts @food.valid?
        # puts @food.persited?
        # puts @user.valid?
        # puts @user.persited?
    #   puts  @food.errors.full_messages
      get foods_path
    end

    it 'Should return successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'Should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'Should include Default text on template' do
      expect(response.body).to include('Food List')
    end

    it 'Should include new recipe' do
        expect(assigns(:foods)).to match_array([@food])
    end

    it 'Should accept params and increase recipes counter' do
      food_params = {
        id:3,
        name: 'soupe al onion',
        measurement_unit: 'kg',
        price: 200,
        quantity: 4
      }
      expect { post foods_path, params: { food: food_params } }.to change(Food, :count)
      expect(response).to redirect_to(foods_path)
    end

    it 'deletes the food' do
        food2 = Food.create(name: 'Food Name', measurement_unit: 'Unit', price: 400, quantity: 2, user: @user)
        expect {
          delete food_path(food2.id)
        }.to change(Food, :count).by(-1)
        expect(response).to redirect_to(foods_path)
    end
  end
end
