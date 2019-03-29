class UserPicturesController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist
  before_action :picture_is_exist,  only: [:edit, :update, :destroy]

  def new
    @picture = @note.user_pictures.build
  end
  def create
    @picture = @note.user_pictures.build(picture_params)
    if @picture.save
      flash[:success] = "UserPicture created"
      redirect_to @note
    else
      render 'new'
    end
  end

  def edit
    @picture = @note.user_pictures.find(params[:id])
  end
  def update
    @picture = @note.user_pictures.find(params[:id])
    if @picture.update_attributes(picture_params)
      flash[:success] = "UserPicture updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.user_pictures.find(params[:id]).destroy
    flash[:success] = "UserPicture deleted"
    redirect_to @note
  end

  private

    def picture_params
      params.require(:user_picture).permit(:picture)
    end

    def note_is_exist
      @note = current_user.user_notes.find_by(id: params[:user_note_id])
      redirect_to root_url if @note.nil?
    end

    def picture_is_exist
      @picture = @note.user_pictures.find_by(id: params[:id])
      redirect_to root_url if @picture.nil?
    end

end
