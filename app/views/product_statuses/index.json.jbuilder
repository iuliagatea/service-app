# frozen_string_literal: true

json.array! @product_statuses, partial: 'product_statuses/product_status', as: :product_status
