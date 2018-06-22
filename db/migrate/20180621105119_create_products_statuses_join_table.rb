class CreateProductsStatusesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :products, :statuses do |ps|
      ps.index [:product_id, :status_id]
    end
  end
end
