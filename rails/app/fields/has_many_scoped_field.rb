class HasManyScopedField < Administrate::Field::HasMany
  def associate_user(user)
    @user = user
  end

  def scoped_associations
    scope_name = "#{self.name.camelize}Policy::Scope"
    scope_const = Object.const_get scope_name
    scope_const.new(@user, @resource.user).resolve
  end

  def candidate_resources
    associations = scoped_associations || associated_class
    if options.key?(:includes)
      includes = options.fetch(:includes)
      associations.includes(*includes).all
    else
      associations.all
    end
  end
end
