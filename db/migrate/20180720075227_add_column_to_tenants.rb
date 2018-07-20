class AddColumnToTenants < ActiveRecord::Migration
  def change
     add_column :tenants, :keywords, :string
  end
end
