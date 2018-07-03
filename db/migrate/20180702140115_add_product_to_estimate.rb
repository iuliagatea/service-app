class AddProductToEstimate < ActiveRecord::Migration
  def change
    add_reference :estimates, :product, index: true, foreign_key: true
  end
end
