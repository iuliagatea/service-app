# frozen_string_literal: true

class TenantCategory < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :category
end
