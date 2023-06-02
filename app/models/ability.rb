class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, RecipeFood
    can :read, Food
    can :read, Recipe do |recipe|
      recipe.public == true
    end
    return unless user.present?

    can(:manage, :all, user:)
  end
end
