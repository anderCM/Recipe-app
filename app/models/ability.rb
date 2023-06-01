class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, RecipeFood
    can :read, Food
    can :read, Recipe
    return unless user.present?

    can(:manage, :all, user:)
    can :read, Recipe
  end
end
