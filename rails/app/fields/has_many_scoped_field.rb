class HasManyScopedField < Administrate::Field::HasMany
  def associate_user(user)
    @user = user
  end

  def scoped_associations
    resources = @resource.send("#{self.name}_candidates", @user)
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
