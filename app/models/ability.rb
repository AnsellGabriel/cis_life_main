# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.is_mis?

    can :read, Member

    return unless user.admin?

    can :manage, :all
  end
end
