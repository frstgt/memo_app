class UserNotesController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist,   except: [:new, :create]

  before_action :user_can_show,     only: [:show]
  before_action :user_can_update,   only: [:edit, :update]
  before_action :user_can_destroy,  only: [:destroy]
  before_action :user_can_move,     only: [:move]

  def show
    @all_memos = @note.memos
    @page_memos = @all_memos.paginate(page: params[:page])
    @pictures = @note.pictures
  end

  def new
    @note = current_user.user_notes.build
    @pen_names = current_user.pen_names
  end
  def create
    @note = current_user.user_notes.build(note_params)
    if @note.save
      flash[:success] = "Note created"

      @note.save_tag_list

      redirect_back_or(current_user)
    else
      render 'new'
    end
  end

  def edit
    @note.load_tag_list
    @pen_names = current_user.pen_names
  end
  def update
    if @note.update_attributes(note_params)
      flash[:success] = "Note updated"

      @note.save_tag_list

      redirect_to @note.redirect_path
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy
    flash[:success] = "Note deleted"

    redirect_back_or(current_user)
  end

  def move
    @note.to_group_note(@group)
    redirect_back_or(current_user)
  end

  private

    def note_params
      params.require(:user_note).permit(:title, :outline, :pen_name_id, :picture, :tag_list, :status, :numbering)
    end

    def note_is_exist
      @note = Note.find_by(id: params[:id])
      redirect_to root_url unless @note
    end

    def user_can_show
      redirect_to root_url unless @note.can_show?(current_user)
    end
    def user_can_update
      redirect_to root_url unless @note.can_update?(current_user)
    end
    def user_can_destroy
      redirect_to root_url unless @note.can_destroy?(current_user)
    end

    def user_can_move
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group and @note.can_move?(current_user, @group)
    end

end
