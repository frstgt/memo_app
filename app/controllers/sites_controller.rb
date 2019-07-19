class SitesController < ApplicationController
  before_action :logged_in_user
  before_action :user_is_admin
  before_action :site_is_exist

  def edit
  end
  def update
    if @site.update_attributes(site_params)
      flash[:success] = "Site updated"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private

    def site_params
      params.require(:site).permit(:name, :outline, :picture, :status)
    end

    def site_is_exist
      @site = Site.first
      redirect_to root_url unless @site
    end

    def user_is_admin
      redirect_to root_url unless current_user.is_admin?
    end

end
