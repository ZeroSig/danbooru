# frozen_string_literal: true

class TagPolicy < ApplicationPolicy
  def can_change_category?
    user.is_admin? ||
      (user.is_builder? && record.post_count < 1_000) ||
      (user.is_member? && record.post_count < 50)
  end

  def can_change_deprecated_status?
    return true if user.is_contributor?
  end

  def permitted_attributes
    permitted = []
    permitted << :category if can_change_category?
    permitted << :is_deprecated if can_change_deprecated_status?
    permitted
  end
end
