# frozen_string_literal: true

class AddPlanToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :plan, :string
  end
end
