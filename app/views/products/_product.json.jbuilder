# frozen_string_literal: true

json.extract! product, :id, :code, :name, :expected_completion_date, :tenant_id, :user_id, :created_at, :updated_at
json.url product_url(product, format: :json)
