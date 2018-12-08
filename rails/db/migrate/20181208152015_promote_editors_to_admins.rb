class PromoteEditorsToAdmins < ActiveRecord::Migration[5.2]
  def up
    User.where(role: :editor).update_all(role: :admin)
  end

  def down
    User.where(role: :admin).update_all(role: :editor)
  end
end
