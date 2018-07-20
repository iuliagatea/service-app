class Category < ActiveRecord::Base
  has_many :tenant_categories
  has_many :tenants, through: :tenant_categories
end
