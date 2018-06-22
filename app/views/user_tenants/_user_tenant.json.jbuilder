json.extract! user_tenant, :id, :user_id, :tenant_id, :created_at, :updated_at
json.url user_tenant_url(user_tenant, format: :json)
