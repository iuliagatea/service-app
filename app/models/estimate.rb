# frozen_string_literal: true

class Estimate < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :product
end
