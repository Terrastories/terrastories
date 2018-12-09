class HasManyScopedField < Administrate::Field::HasMany
  def self.html_class
    "has-many"
  end

  def associate_user(user)
    @user = user
  end

  def data
    full_data = super
    @user ? scope_class.new(@user, full_data).resolve : full_data
  end

  def model_name
    "#{self.name.camelize}"
  end

  def model_class
    Object.const_get model_name
  end

  def scope_name
    "#{model_name}Policy::Scope"
  end

  def scope_class
    Object.const_get scope_name
  end
end
