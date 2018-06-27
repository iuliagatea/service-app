class Product < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :user
  accepts_nested_attributes_for :user
  
  def self.by_tenant(tenant_id)
    tenant = Tenant.find(tenant_id)
    tenant.products
  end
  
  def self.by_member(user_id)
    user = User.find(user_id)
    user.products
  end
end
