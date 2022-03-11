# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET #index' do
    subject { get :index }
    context 'when logged id' do
      let(:tenant) { create(:tenant, :free) }
      let(:user) { create(:user, :admin) }
      before(:each) do
        set_current_tenant(tenant)
        login(user)
      end

      it 'redirects to tenant products' do
        subject
        expect(response).to redirect_to(tenant_products_path(tenant))
      end
    end

    context 'not logged in' do
      before do
        subject
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end
    end
  end
end
