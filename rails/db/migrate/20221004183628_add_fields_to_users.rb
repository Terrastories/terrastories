class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def up
    # don't set default/null when adding column to avoid excessive writes
    add_column :users, :username, :string
    add_column :users, :name, :string

    # automatically set all users usernames to their email for backwards compat
    User.where(username: nil).find_each do |user|
      user.update(username: user.email)
    end

    # now set default and null
    change_column_default :users, :username, ""
    change_column_null :users, :username, false

    # and index
    add_index :users, :username, unique: true

    # and allow email to be nil
    change_column_default :users, :email, nil
    change_column_null :users, :email, true
  end

  def down
    User.where(email: [nil, ""]).find_each do |user|
      user.email = user.username
      user.save!(validate: false)
    end

    # Remove new columns
    remove_column :users, :username
    remove_column :users, :name

    # Revert default and null on email
    change_column_default :users, :email, ""
    change_column_null :users, :email, false
  end
end
