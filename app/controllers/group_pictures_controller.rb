class GroupPicturesController < ApplicationController
  before_action :logged_in_user
  before_action :group_is_exist
  before_action :note_is_exist
  before_action :user_have_member

  before_action :picture_is_exist,          except: [:new, :create]

  before_action :user_have_regular_member,    only: [:edit, :update, :destroy]

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

    def group_is_exist
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group
    end
    def note_is_exist
      @note = @group.group_notes.find_by(id: params[:group_note_id])
      redirect_to root_url unless @note
    end
    def picture_is_exist
      @picture = @note.group_pictures.find_by(id: params[:id])
      redirect_to root_url unless @picture
    end

    def user_have_member
      @user_member = @group.get_user_member(current_user)
      redirect_to root_url unless @user_member
    end

    def user_have_regular_member
      redirect_to root_url unless @group.user_is_regular_member?(@user_member)
    end

end
