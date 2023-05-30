class RecipeFoodsController < ApplicationController
    def index
      @recipe_names = Recipe.includes(:user).where(public: true).order(created_at: :desc)
    end
  end
  