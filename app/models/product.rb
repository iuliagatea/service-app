class Product < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :user
  has_many :product_statuses
  has_many :statuses, through: :product_statuses
  has_many :estimates, inverse_of: :product
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :estimates, reject_if: :all_blank, allow_destroy: true
  
  def last_status
    status = ProductStatus.where(product_id: id).last.status_id
    Status.find(status)
  end
  
  def estimated_value
    if self.estimates.count > 0
      self.estimates.sum("price * quantity")
    else
      0
    end
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
