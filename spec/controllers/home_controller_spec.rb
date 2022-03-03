# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET #index' do
    context 'when logged id' do
      let(:tenant) { create(:tenant) }
      let(:user) { create(:user) }
      before(:each) do
        set_current_tenant(tenant)
        login(user)
        get :index
      end

      it 'redirects to tenant products' do
        expect(response).to redirect_to(tenant_products_path(tenant))
      end
    end

    context 'not logged in' do
      before do
        get :index
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
