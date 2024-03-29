# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text :entity
      t.text :name

      t.timestamps null: false
    end
  end
end
