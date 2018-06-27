class MembersController < ApplicationController

  # uncomment to ensure common layout for forms
  # layout  "sign", :only => [:new, :edit, :create]

  def new()
    @member = Member.new()
    @user   = User.new()
  end

  def create()
    @user   = User.new( user_params )
  
    # ok to create user, member
    if @user.save_and_invite_member() && @user.create_member( member_params )
      flash[:notice] = "New member added and invitation email sent to #{@user.email}."
      redirect_to root_path
    else
      flash[:error] = "errors occurred!"
      @member = Member.new( member_params ) # only used if need to revisit form
      render :new
    end

  end

  def get_name 
    if params[:email].present? 
        @user = User.find_by_email(params[:email]).first
        @member = Member.where("user_id = #{@user.id}")
        @data = Hash.new 
        # @data["first_name"] = @member.first_name
        # @data["last_name"] = @member.last_name 
        @data["first_name"] = "Iulia"
        @data["last_name"] = "B"
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

end
