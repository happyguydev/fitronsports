# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(account)
    return if account.blank?

    alias_action :create, :read, :update, :destroy, to: :crud

    if account.janitor?
      can :crud, Janitor, id: account.id
      can [:edit_password, :update_password], Janitor, id: account.id
      can [:completion], Janitor

      can [:create, :read], Request, janitor_account_id: account.id
      can [:edit, :update, :destroy], Request, status: :draft
      # [UPDATE] attachment's owner request validation?
      can [:create, :read, :destroy], Attachment, request: { janitor_account_id: account.id }
      can [:edit, :update], Attachment, request: { janitor_account_id: account.id, status: :draft }
    end

    if account.inspector?
      can :crud, Inspector, id: account.id
      can [:edit_password, :update_password], Inspector, id: account.id
      can [:completion], Inspector

      can [:create, :read, :edit], Report, inspector_account_id: account.id
      can [:update, :destroy], Report, status: :draft
      
    end

    can :read, Product
  end
end
