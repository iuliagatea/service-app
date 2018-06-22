class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_universal_and_determines_account
  has_one :member, :dependent => :destroy
  has_many :user_products
  has_many :products, through: :user_products
  validate :free_plan_can_only_have_500_users
  has_many :user_tenants
  has_many :tenants, through: :user_tenants

  def is_admin?
    is_admin
  end
  
  def free_plan_can_only_have_500_users
    if self.new_record? && (tenant.users.count > 499) && (tenant.plan == 'free')
      errors.add(:base, "Free plans cannot have more than 500 users")
    end
  end
  
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
  
  def self.find_by_email(email)
    where(email: email).first
  end
end
