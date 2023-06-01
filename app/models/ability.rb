class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, RecipeFood
    can :read, Food
    can :manage, Recipe
    return unless user.present?

    can :manage, :all, user:

    #   can :read, :all
    #   can :create, :all
    #   can :destroy, Post do |post|
    #     post.author == user
    #   end
    #   can :destroy, Comment do |comment|
    #     comment.author == user
    #   end

    #   return unless user.role == 'admin'

    #   can :manage, :all
    #   can :destroy, Post
    #   can :destroy, Comment
  end
end
