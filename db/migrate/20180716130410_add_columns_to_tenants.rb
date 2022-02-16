# frozen_string_literal: true

class AddColumnsToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :description, :string
  end
end
