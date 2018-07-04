class Status < ActiveRecord::Base
  belongs_to :tenant
  has_many :product_statuses
  has_many :products, through: :product_statuses
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :tenant
  
  def products_with_status
    prods = []
    pss = ProductStatus.where(status_id: id)
    pss.each do |ps|
      p = Product.find(ps.product_id)
      if ps.status_id == p.last_status.id
        prods << p
      end
    end
    prods.uniq
  end
  
  def products_with_status_by_user(user)
    prods = []
    pss = ProductStatus.where(status_id: id)
    pss.each do |ps|
      p = Product.find(ps.product_id)
      if ps.status_id == p.last_status.id and p.user_id == user.id
        prods << p
      end
    end
    prods.uniq
  end
  
  def self.by_tenant(tenant_id)
    tenant = Tenant.find(tenant_id)
    tenant.statuses
  end
  
  def self.by_product(product_id)
    product = Product.find(product_id)
    product.statuses
  end
end
