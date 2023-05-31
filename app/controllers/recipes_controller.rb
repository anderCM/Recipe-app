class RecipesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  def index
    @recipes = Recipe.where(user: current_user)
  end

  def new
    @recipes = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      redirect_to recipes_path, notice: 'Recipe was successfully created'
    else
      render :new
    end
  end

  def show
    render :show
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description)
  end
end
