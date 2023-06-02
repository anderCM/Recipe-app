class RecipesController < ApplicationController
  before_action :authenticate_user!, except: %i[show details]
  load_and_authorize_resource
  skip_load_and_authorize_resource only: :details
  def index
    @recipes = Recipe.where(user: current_user).order(created_at: :desc)
  end

  def new
    @recipes = Recipe.new
  end

  def new_ingredient
    @food = Food.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    begin
      @recipe.save
      redirect_to recipes_path, notice: 'Recipe was created successfully'
    rescue StandardError => e
      render :new, alert: "Failed to delete recipe: #{e.message}"
    end
  end

  def add_ingredient
    @food = Food.new(food_params)
    @food.user = current_user
    @quantity = @food.quantity

    @recipe = Recipe.find(params[:id])

    @recipe_food = RecipeFood.new(food: @food, recipe: @recipe, quantity: @quantity)

    if @recipe_food.save
      redirect_to recipe_path(params[:id]), notice: 'Food added to recipe successfully'
    else
      render :new_ingredient
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_foods = RecipeFood.includes(:food).where(recipe: @recipe)
    @foods = @recipe_foods.map do |food|
      Food.find(food.food_id)
    end
  end

  def destroy_food
    @food = Food.find(params[:food_id])
    @recipe = Recipe.find(params[:id])
    @recipe_food = RecipeFood.find_by(food: @food, recipe: @recipe)
    if @recipe_food.destroy
      redirect_to recipe_path(:id), notice: 'Food deleted successfully'
    else
      redirect_to recipe_path(:id), notice: 'Failed to delete food.'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    begin
      @recipe.destroy
      redirect_to recipes_path, notice: 'Recipe deleted successfully.'
    rescue StandardError => e
      redirect_to recipes_path, alert: "Failed to delete recipe: #{e.message}"
    end
  end

  def details
    @recipe = Recipe.find(params[:id])
    @recipe_foods = RecipeFood.includes(:food).where(recipe: @recipe)
    @total_price = @recipe_foods.sum { |food| food.food.price * food.quantity }
  end

  def update_toggle
    toggle_value = params[:toggle].to_i == 1
    @recipe = Recipe.find(params[:id])

    @recipe.public = toggle_value
    if @recipe.save
      flash[:notice] = 'Recipe successfully updated.'
      redirect_to recipe_path(params[:id])
    else
      redirect_to recipe_path(params[:id]), notice: 'Error with update.'
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description)
  end

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity)
  end
end
