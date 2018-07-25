class MembersController < ApplicationController

  # uncomment to ensure common layout for forms
  # layout  "sign", :only => [:new, :edit, :create]
  before_action :verify_admin
  
  def new()
    @member = Member.new()
    @user   = User.new()
  end

  def create()
    @user   = User.new( user_params )
  
    # ok to create user, member
    if @user.save_and_invite_member() && @user.create_member( member_params )
      flash[:notice] = "New member added and invitation email sent to #{@user.email}."
      logger.debugg "Creating user and sending email #{@user.attributes.inspect}"
      redirect_to root_path
    else
      flash[:error] = "errors occurred!"
      logger.error "Error occurred while creating user #{@user.attributes.inspect}"
      @member = Member.new( member_params ) # only used if need to revisit form
      render :new
    end

  end

  def get_name 
    if params[:email].present? 
        @user = User.find_by_email(params[:email]).first
        @tenant = Tenant.current_tenant
        Tenant.set_current_tenant(@user.tenants.first)
        @data = Hash.new 
        @data["first_name"] = @user.member.first_name
        @data["last_name"] = @user.member.last_name 
        Tenant.set_current_tenant(@tenant)
        render json: @data and return false 
    end 
  end

  private

  def member_params()
    params.require(:member).permit(:first_name, :last_name)
  end

  def user_params()
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
  def verify_admin
    unless current_user.is_admin
      redirect_to :root, 
          flash: { error: 'You are not authorized to do this action' }
    end
  end

end
