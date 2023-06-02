require 'rails_helper'

RSpec.feature 'Recipe Food', type: :feature do
  # View test cases will be written here
  before do
    @user = User.create(
      name: Faker::Name.first_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )

    @recipe2 = Recipe.create(name: Faker::Food.dish,
                             preparation_time: Faker::Time.between(from: DateTime.now,
                                                                   to: DateTime.now + 7),
                             cooking_time: Faker::Time.between(from: DateTime.now,
                                                               to: DateTime.now + 7),
                             description: Faker::Lorem.paragraph,
                             public: Faker::Boolean.boolean,
                             user: @user)

    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'

    visit '/public_recipes'
  end
  scenario 'User can see the public recipe' do
    visit '/public_recipes'
    expect(page).to have_content('Public Recipes')
  end

  scenario 'User can navigate from public recipe page to recipe/recipe_id' do
    visit '/public_recipes'
    my_link = find_by_id("public_recipe_link_#{@recipe2.id}")
    my_link.click
    expect(page).to have_content('recipe Details')
    expect(page).to have_selector('form')
  end
end
