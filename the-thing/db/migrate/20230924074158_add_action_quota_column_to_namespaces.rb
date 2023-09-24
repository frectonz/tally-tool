class AddActionQuotaColumnToNamespaces < ActiveRecord::Migration[7.0]
  def change
    add_column :namespaces, :action_quota, :integer, :default => 0
  end
end
