class GroupNotesController < ApplicationController
  before_action :logged_in_user
  before_action :group_is_exist
  before_action :note_is_exist,     except: [:new, :create]

  before_action :user_can_show,       only: [:show]
  before_action :user_can_create,     only: [:new, :create]
  before_action :user_can_update,     only: [:edit, :update]
  before_action :user_can_destroy,    only: [:destroy]
  before_action :user_can_move,       only: [:move]

  def show
    @all_memos = @note.memos
    @page_memos = @all_memos.paginate(page: params[:page])
    @pictures = @note.pictures
  end

  def new
    @note = @group.group_notes.build
    @pen_names = @group.members
  end
  def create
    @note = @group.group_notes.build(note_params)
    if @note.save
      flash[:success] = "Note created"

      @note.save_tag_list

      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
    @note.load_tag_list
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
    redirect_to @group
  end

  def move
    @note.to_user_note(current_user)
    redirect_to @group
  end

  private

    def note_params
      params.require(:group_note).permit(:title, :outline, :pen_name_id, :picture, :tag_list, :status, :numbering)
    end

    def group_is_exist
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group
    end
    def note_is_exist
      @note = Note.find_by(id: params[:id])
      redirect_to root_url unless @note
    end

    def user_can_show
      redirect_to root_url unless @note.can_show?(current_user)
    end
    def user_can_create
      member = @group.get_user_member(current_user)
      redirect_to root_url unless member and @group.is_regular_member?(member)
    end
    def user_can_update
      redirect_to root_url unless @note.can_update?(current_user)
    end
    def user_can_destroy
      redirect_to root_url unless @note.can_destroy?(current_user)
    end

    def user_can_move
      redirect_to root_url unless @note.can_move?(current_user)
    end

end
