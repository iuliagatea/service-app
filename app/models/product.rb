class Product < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :user
  has_many :product_statuses
  has_many :statuses, through: :product_statuses
  accepts_nested_attributes_for :user
  
  def last_status
    status = ProductStatus.where(product_id: id).last.status_id
    Status.find(status)
  end
  
  def self.by_tenant(tenant_id)
    tenant = Tenant.find(tenant_id)
    tenant.products
  end
  
  def self.by_member(user_id)
    user = User.find(user_id)
    user.products
  end
  
end
