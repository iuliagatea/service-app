RSpec.shared_context 'initialize' do
  let(:tenant) { create(:tenant, :free) }
  let(:admin_user) { create(:user, :admin) }
  let(:customer) { create(:user, :regular, member: create(:member)) }
  let(:products) { create_list(:product, 10, tenant_id: tenant.id, user: customer, statuses: [tenant.statuses.first]) }
  let(:product) { products.first }
  before do
    set_current_tenant(tenant)
    login(admin_user)
  end
end