class GroupPicturesController < GroupBaseController
  before_action :note_is_exist
  before_action :user_have_member

  before_action :picture_is_exist,          except: [:new, :create]

  before_action :user_have_regular_member,    only: [:new, :create, :edit, :update, :destroy]

  def new
    @picture = @note.group_pictures.build
  end
  def create
    @picture = @note.group_pictures.build(picture_params)
    if @picture.save
      flash[:success] = "GroupPicture created"
      redirect_to group_group_note_path(@group, @note)
    else
      render 'new'
    end
  end

  def edit
    @picture = @note.group_pictures.find(params[:id])
  end
  def update
    @picture = @note.group_pictures.find(params[:id])
    if @picture.update_attributes(picture_params)
      flash[:success] = "GroupPicture updated"
      redirect_to group_group_note_path(@group, @note)
    else
      render 'edit'
    end
  end

  def destroy
    @note.group_pictures.find(params[:id]).destroy
    flash[:success] = "GroupPicture deleted"
    redirect_to group_group_note_path(@group, @note)
  end

  private

    def picture_params
      params.require(:group_picture).permit(:picture)
    end

    def note_is_exist
      @note = @group.group_notes.find_by(id: params[:group_note_id])
      redirect_to root_url unless @note
    end
    def picture_is_exist
      @picture = @note.group_pictures.find_by(id: params[:id])
      redirect_to root_url unless @picture
    end

end
