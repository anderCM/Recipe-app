class Ability
    include CanCan::Ability
  
    def initialize(user)
      return unless user.present?
  
      can :read, :all
      can :create, :all
      
    end
  end