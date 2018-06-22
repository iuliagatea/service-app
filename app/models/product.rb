class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :tenant
  has_one :user
  has_many :product_statuses
  has_many :statuses, through: :product_statuses
  validates_presence_of :name
  
  def self.by_user_plan_and_tenant(tenant_id, user)
    tenant = Tenant.find(tenant_id)
    if tenant.plan == 'premium'
      if user.is_admin?
        tenant.users
      else
        user.products.where(tenant_id: tenant.id)
      end
    else
      if user.is_admin?
        tenant.users.order(:id).limit(500)
      else
        user.products.where(tenant_id: tenant.id).order(:id).limit(500)
      end
    end
  end
end
