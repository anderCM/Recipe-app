class RecipesController < ApplicationController
  before_action :authenticate_user!
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
    @recipes = Recipe.find(params[:id])
    @recipe_foods = RecipeFood.includes(:food).find(params[:id])
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

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description)
  end
end
