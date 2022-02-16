# frozen_string_literal: true

class ProductStatus < ActiveRecord::Base
  belongs_to :product
  belongs_to :status

  def self.last_by_product(product_id)
    where(product_id: product_id).last.status_id if product_id
  end
end
