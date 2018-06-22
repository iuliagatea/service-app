class AddStatusToProducts < ActiveRecord::Migration
  def change
    add_column :products, :status_id, :integer
  end
end
