class FoodsController < ApplicationController
  load_and_authorize_resource
  def index
    if current_user
      @foods = Food.where(user_id: current_user.id)
    else
      redirect_to user_session_path
    end
  end

  def new
    @food = Food.new
  end

  def create
    # authorize! :create, @food
    @food = Food.new(food_params)
    @food.user_id = current_user.id

    if @food.save
      redirect_to '/foods', notice: 'Food was successfully created'
    else
      render :new
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity)
  end
end
