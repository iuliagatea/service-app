# frozen_string_literal: true

class AddColumnToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :keywords, :string
  end
end
