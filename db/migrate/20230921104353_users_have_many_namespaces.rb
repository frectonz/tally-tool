class UsersHaveManyNamespaces < ActiveRecord::Migration[7.0]
  def change
    add_reference :namespaces, :user, foreign_key: true
  end
end
