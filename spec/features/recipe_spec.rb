require 'rails_helper'
require 'faker'

RSpec.feature 'Recipe', type: :feature do
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
                             public: true,
                             user: @user)
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'

    visit '/recipes'
  end
  scenario 'User can see the public recipe' do
    visit '/recipes'
    expect(page).to have_content('List of recipes')
  end

  scenario 'User can navigate from public recipe page to recipe/recipe_id' do
    visit '/recipes'
    my_link = find_by_id("recipe_link_#{@recipe2.id}")
    my_link.click
    expect(page).to have_content('recipe Details')
    expect(page).to have_selector('form')
  end

  scenario 'User can navigate from recipe page to recipes/new page' do
    visit '/recipes'
    add_recipe = find_by_id('add-recipe')
    add_recipe.click
    expect(page).to have_content('Recipe details')
    expect(page).to have_selector('form')
  end

  scenario 'User can delete a recipe' do
    @new_recipe = Recipe.create(name: Faker::Food.dish,
    preparation_time: Faker::Time.between(from: DateTime.now,
                                          to: DateTime.now + 7),
    cooking_time: Faker::Time.between(from: DateTime.now,
                                      to: DateTime.now + 7),
    description: Faker::Lorem.paragraph,
    public: true,
    user: @user)

    visit '/recipes'
    expect(page).to have_content(@new_recipe.name)
    delete_link = find_by_id("delete-recipe-#{@new_recipe.id}")
    delete_link.click
    expect(page).not_to have_content(@new_recipe.name)
  end
end
