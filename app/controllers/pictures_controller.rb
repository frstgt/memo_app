class PicturesController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist
  before_action :picture_is_exist,  except: [:new, :create]

  def new
    @picture = @note.pictures.build
  end
  def create
    @picture = @note.pictures.build(picture_params)
    if @picture.save
      flash[:success] = "Picture created"

      redirect_to @note.redirect_path
    else
      render 'new'
    end
  end

  def edit
    @picture = @note.pictures.find(params[:id])
  end
  def update
    @picture = @note.pictures.find(params[:id])
    if @picture.update_attributes(picture_params)
      flash[:success] = "Picture updated"

      redirect_to @note.redirect_path
    else
      render 'edit'
    end
  end

  def destroy
    @note.pictures.find(params[:id]).destroy
    flash[:success] = "Picture deleted"

    redirect_to @note.redirect_path
  end

  private

    def picture_params
      params.require(:picture).permit(:picture)
    end

    def note_is_exist
      @note = Note.find_by(id: params[:note_id])
      redirect_to root_url unless @note && @note.can_update?(current_user)
    end

    def picture_is_exist
      @picture = @note.pictures.find_by(id: params[:id])
      redirect_to root_url if @picture.nil?
    end

end
