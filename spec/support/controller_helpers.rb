module ControllerHelpers
  def set_current_tenant(tenant)
    Tenant.set_current_tenant tenant
  end

  def login(user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      allow(controller).to receive(:current_user).and_return(user)
  end
end
