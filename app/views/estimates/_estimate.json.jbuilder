# frozen_string_literal: true

json.extract! estimate, :id, :name, :quantity, :price, :value, :tenant_id, :created_at, :updated_at
json.url estimate_url(estimate, format: :json)
