require 'rails_helper'
require 'faker'

RSpec.feature 'Food', type: :feature do
  # View test cases will be written here
  before do
    @user = User.create(
      name: Faker::Name.first_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )

    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'

    visit '/foods'
  end
  scenario 'User can see the homepage' do
    visit '/foods'
    expect(page).to have_content('Food List')
  end

  scenario 'User can navigate from home page to foods/new page' do
    visit '/foods/new'
    click_button 'Add Food'
    expect(page).to have_content('Add Food')
    expect(page).to have_selector('form')
  end
  scenario 'User can delete a food' do
    @name = Faker::Food.unique.ingredient
    @measurement_unit = Faker::Food.measurement
    @price = Faker::Number.number(digits: 10)
    @quantity = Faker::Number.between(from: 1, to: 10)

    @food = Food.create(name: @name, measurement_unit: @measurement_unit, price: @price, quantity: @quantity,
                        user: @user)

    visit '/foods'
    expect(page).to have_content(@food.name)

    click_button 'Delete'

    expect(page).not_to have_content(@food.name)
  end
end
