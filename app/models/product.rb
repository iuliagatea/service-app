class Product < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :user
  has_many :product_statuses
  has_many :statuses, through: :product_statuses, :dependent => :destroy
  has_many :estimates, inverse_of: :product, :dependent => :destroy
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :estimates, reject_if: :all_blank, allow_destroy: true
  validate :free_plan_can_only_have_500_products

  def free_plan_can_only_have_500_products
    if new_record? && (tenant.products.count > 499) && (tenant.plan == 'free')
      errors.add(:base, 'Free plans cannot have more than 500 products')
    end
  end

  def last_status
    Status.find(ProductStatus.where(product_id: id).last.status_id)
  end

  def estimated_value
    estimates.count > 0 ? estimates.sum('price * quantity') : 0
  end

  def self.by_tenant_and_user(tenant_id, user_id)
    Product.where(tenant_id: tenant_id, user_id: user_id)
  end
end
