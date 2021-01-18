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

  private

  def guest_abilities
    can :read, :all
    can :get_email, User
    can :set_email, User
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities(user)
    guest_abilities
    can :create, [Question, Answer]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :choose_best, Answer do |answer|
      answer.question.user_id == user.id
    end

    can :add_comment, [Question, Answer]
    can :destroy_comment, Comment, user_id: user.id

    alias_action :thumb_up, :thumb_down, :cancel_voice, to: :vote

    can :vote, [Question, Answer] do |ratinged|
      ratinged.user_id != user.id
    end

    can :index, Reward

    can :destroy, ActiveStorage::Attachment, record: {user_id: user.id}
  end
end
