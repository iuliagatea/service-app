module ControllerHelpers
  def create_session_with_products
    set_current_tenant(tenant)
    login(admin_user)
    products
  end

  def set_current_tenant(tenant)
    Tenant.set_current_tenant tenant
  end

  def login(user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      controller.stub authenticate_user!: true,
                      current_user: user
  end
  shared_examples_for 'redirect if not logged in' do
    it 'redirects to sign in path' do
      expect(subject).to redirect_to(new_user_session_path)
    end
  end
end
