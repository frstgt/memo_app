class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update, :destroy]
  before_action :user_can_create, only: [:new, :create]
  before_action :user_can_destroy, only: [:destroy]

  def show
    store_location

    @user = User.find(params[:id])
    @all_notes = @user.user_notes.where(pen_name_id: nil)
    @all_rooms = @user.user_rooms.where(pen_name_id: nil)
    @page_notes = @all_notes.paginate(page: params[:page])
    @page_rooms = @all_rooms.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Memo App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Account deleted"
    redirect_to root_url
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :password,
                                   :password_confirmation, :keyword)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def user_can_create
      redirect_to root_url unless User::can_create?(current_user)
    end

    def user_can_destroy
      redirect_to root_url unless @user.can_destroy?(current_user)
    end

end
