json.extract! product_status, :id, :product_id, :status_id, :created_at, :updated_at
json.url product_status_url(product_status, format: :json)
