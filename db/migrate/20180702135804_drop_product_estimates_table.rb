class DropProductEstimatesTable < ActiveRecord::Migration
  def change
    drop_table :product_estimates
  end
end
