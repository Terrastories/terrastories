class HasManyScopedField < Administrate::Field::HasMany
  def associate_user(user)
    @user = user
  end

  def scoped_associations
    model_name = "#{self.name.camelize}"
    model_const = Object.const_get model_name
    scope_name = "#{model_name}Policy::Scope"
    scope_const = Object.const_get scope_name
    scope_const.new(@user, model_const).resolve
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
