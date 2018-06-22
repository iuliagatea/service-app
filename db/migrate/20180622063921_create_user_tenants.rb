class CreateUserTenants < ActiveRecord::Migration
  def change
    create_table :user_tenants do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :tenant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
