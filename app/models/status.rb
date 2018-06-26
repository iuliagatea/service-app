class Status < ActiveRecord::Base
  belongs_to :tenant
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.by_tenant(tenant_id)
    tenant = Tenant.find(tenant_id)
    tenant.statuses
  end
end
