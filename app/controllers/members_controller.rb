class MembersController < ApplicationController

  # uncomment to ensure common layout for forms
  # layout  "sign", :only => [:new, :edit, :create]

  def new()
    @member = Member.new()
    @user   = User.new()
    @statuses = Status.all
  end

  def create()
    @statuses = Status.all
    @user   = User.new( user_params )
    # ok to create user, member
    if @user.save_and_invite_member() && @user.create_member( member_params )
      flash[:notice] = "New member added and invitation email sent to #{@user.email}."
      @product = Product.new(product_params)
      @product.tenant_id = Tenant.current_tenant_id
      @product.user_id = @user.id
      @product.save
      redirect_to root_path
    else
      flash[:error] = "errors occurred!"
      @member = Member.new( member_params ) # only used if need to revisit form
      render :new
    end

  end


  private

  def member_params()
    params.require(:member).permit(:first_name, :last_name)
  end

  def user_params()
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
  def product_params
    params.require(:product).permit(:code, :name, :status)
  end

end
