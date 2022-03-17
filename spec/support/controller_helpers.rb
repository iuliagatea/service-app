module ControllerHelpers
  def set_current_tenant(tenant)
    Tenant.set_current_tenant tenant
  end

  def login(user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      controller.stub authenticate_user!: true,
                      current_user: user
  end

  def logout(user)
    sign_out user
  end

  shared_examples_for 'redirect if not logged in' do
    let(:tenant) { Tenant.first }
    let(:product) { Product.first }
    before do
      set_current_tenant(0)
      logout(admin_user)
    end

    it 'redirects to sign in path' do
      expect(subject).to redirect_to(new_user_session_path)
    end
  end
end
