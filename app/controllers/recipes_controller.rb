class RecipesController < ApplicationController
  before_action :authenticate_user!, except: %i[show details]
  load_and_authorize_resource
  def index
    @recipes = Recipe.where(user: current_user).order(created_at: :desc)
  end

  def new
    @recipes = Recipe.new
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

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_foods = RecipeFood.includes(:food).where(recipe: @recipe)
    @foods = @recipe_foods.map do |food|
      Food.find(food.food_id)
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

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description)
  end
end
