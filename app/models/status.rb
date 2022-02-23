# frozen_string_literal: true

class Status < ActiveRecord::Base
  belongs_to :tenant
  has_many :product_statuses
  has_many :products, through: :product_statuses
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :tenant

  def status_products(user)
    product_statuses.map(&:product).uniq.select do |product|
      product.current_status.id == id && (product.user_id == user.id || user.is_admin)
    end
  end
end
