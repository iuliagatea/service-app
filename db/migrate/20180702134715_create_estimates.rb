class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.string :name
      t.float :quantity
      t.float :price
      t.float :value
      t.belongs_to :tenant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
