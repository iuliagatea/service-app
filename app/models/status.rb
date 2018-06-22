class Status < ActiveRecord::Base
  belongs_to :tenant
  has_one :tenant

end
