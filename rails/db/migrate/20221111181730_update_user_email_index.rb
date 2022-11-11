class UpdateUserEmailIndex < ActiveRecord::Migration[6.1]
  def up
    # remove old index
    remove_index :users, :email
    # re-add without unique clause
    add_index :users, :email
  end

  def down
    # irreversible, since we are not guaranteed to be able to
    # add a unique index back to the email field.
  end
end
