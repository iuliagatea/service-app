class TenantCategory < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :category
end
