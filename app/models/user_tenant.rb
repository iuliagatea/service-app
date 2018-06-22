class UserTenant < ActiveRecord::Base
  belongs_to :user
  belongs_to :tenant
end
