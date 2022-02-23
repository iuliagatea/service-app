# frozen_string_literal: true

class ProductStatus < ActiveRecord::Base
  belongs_to :product
  belongs_to :status

end
