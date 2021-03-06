class SessionsController < ApplicationController

  def new
  end
  
  def create
    @user = User.find_by(name: params2d(:session, :name))
    if @user && @user.authenticate(params2d(:session, :password))
      log_in @user
      
      if @user.is_admin? && Site.count == 0
        Site.create()
      end
      
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid name/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
