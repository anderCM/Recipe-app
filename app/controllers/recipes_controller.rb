class RecipesController < ApplicationController
# load_and_authorize_resource
  def index; end

  def show
    @recipes = Recipe.find(params[:id])
    @recipe_foods = RecipeFood.includes(:food).find(params[:id])
  end
end
