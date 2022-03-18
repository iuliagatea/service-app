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
end
