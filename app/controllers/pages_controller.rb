class PagesController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :about ]
  before_action :verify_user
  
  def about

  end
  
  private
    def verify_user
      if current_user
        unless params[:user_id] == current_user.to_s or current_user.is_admin
          redirect_to :root, 
              flash: { error: 'You are not authorized to do this action' }
        end
      end
    end
end