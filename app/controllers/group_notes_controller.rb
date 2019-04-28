class GroupNotesController < GroupBaseController
  before_action :user_have_member,       except: [:show]
  before_action :note_is_exist,          except: [:new, :create]

  before_action :allowed_user,             only: [:show]

  before_action :note_is_open,             only: [:to_close]
  before_action :note_is_close,            only: [:to_open]

  before_action :user_have_leading_member, only: [:new, :create, :destroy,
                                                  :to_open, :to_close]
  before_action :user_have_regular_member, only: [:edit, :update]

  def show # for all
    @all_memos = @note.group_memos
    @page_memos = @all_memos.paginate(page: params[:page])
  end
  def home # for members
    @pictures = @note.group_pictures
    @all_memos = @note.group_memos
    @page_memos = @all_memos.paginate(page: params[:page])
  end

  def new
    @note = @group.group_notes.build
  end

  def create
    @note = @group.group_notes.build(note_params)
    if @note.save
      flash[:success] = "Note created"
      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
    @note = @group.group_notes.find(params[:id])
  end

  def update
    @note = @group.group_notes.find(params[:id])
    if @note.update_attributes(note_params)
      flash[:success] = "Note updated"
      redirect_to @group
    else
      render 'edit'
    end
  end

  def destroy
    @group.group_notes.find(params[:id]).destroy
    flash[:success] = "Note deleted"
    redirect_to @group
  end

  #

  def to_open
    @note.to_open
    redirect_to group_group_note_path(@group, @note)
  end
  def to_close
    @note.to_close
    redirect_to group_group_note_path(@group, @note)
  end

  private

    def note_params
      params.require(:group_note).permit(:title, :description, :pen_name_id, :picture)
    end

    def note_is_exist
      @note = @group.group_notes.find_by(id: params[:id])
      redirect_to root_url unless @note
    end

    def note_is_open
      unless @note.is_open?
        redirect_to root_url
      end
    end
    def note_is_close
      unless not @note.is_open?
        redirect_to root_url
      end
    end

    def allowed_user
      @user_member = @group.get_user_member(current_user)
      unless @user_member or @note.is_open?
        redirect_to root_url
      end
    end

end
