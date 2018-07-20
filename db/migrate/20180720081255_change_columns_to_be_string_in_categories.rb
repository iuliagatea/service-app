class ChangeColumnsToBeStringInCategories < ActiveRecord::Migration
  def change
    change_column :categories, :entity, :string
    change_column :categories, :name, :string
  end
end
