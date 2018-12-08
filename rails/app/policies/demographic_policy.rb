class DemographicPolicy < EditorOnlyPolicy
  attr_reader :user, :demographic

  class Scope < EditorOnlyPolicy::Scope
    attr_reader :user, :scope

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.demographic)
      end
    end
  end
end
