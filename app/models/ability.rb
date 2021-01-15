# frozen_string_literal: true
class Ability
  include CanCan::Ability


  def initialize(user)
    if user
      user.admin? ? admin_abilities : user_abilities(user)
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities(user)
    guest_abilities
    can :create, [Question, Answer]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :add_comment, Question
    can :destroy_comment, Comment, user_id: user.id

    can :choose_best, Answer, question: { user: user }

    can [:thumb_up, :thumb_down, :cancel_voice], [Question, Answer] do |ratinged|
      ratinged.user_id != user.id
    end

    can :index, Reward

  end
end
