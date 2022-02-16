# frozen_string_literal: true

class CreateTenantCategories < ActiveRecord::Migration
  def change
    create_table :tenant_categories do |t|
      t.references :tenant, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
