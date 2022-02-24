# frozen_string_literal: true

class AddColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :comments, :text
  end
end
