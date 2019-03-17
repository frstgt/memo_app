class GroupMemosController < MemosController
  before_action :logged_in_user
  before_action :group_is_exist
  before_action :note_is_exist
  before_action :user_have_member

  before_action :memo_is_exist,          except: [:new, :create]

  before_action :user_have_regular_member, only: [:edit, :update, :destroy]

  def new
    @memo = @note.group_memos.build
    @max = @value = @note.group_memos.count + 1
  end

  def create
    @memo = @note.group_memos.build(memo_params)
    if @memo.save

      update_number(@note.group_memos, @memo)

      flash[:success] = "Memo created"
      redirect_to @note
    else
      render 'new'
    end
  end

  def edit
    @memo = @note.group_memos.find(params[:id])
    @max = @note.group_memos.count + 1
    @value = @memo.number
  end

  def update
    @memo = @note.group_memos.find(params[:id])
    if @memo.update_attributes(memo_params)

      update_number(@note.group_memos, @memo)

      flash[:success] = "Memo updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.group_memos.find(params[:id]).destroy
    flash[:success] = "Memo deleted"
    redirect_to @note
  end

  private

    def memo_params
      params.require(:group_memo).permit(:title, :content, :picture, :number)
    end

    def group_is_exist
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group
    end
    def note_is_exist
      @note = @group.group_notes.find_by(id: params[:group_note_id])
      redirect_to root_url unless @note
    end
    def memo_is_exist
      @memo = @note.group_memos.find_by(id: params[:id])
      redirect_to root_url unless @memo
    end

    def user_have_member
      @user_member = @group.get_user_member(current_user)
      redirect_to root_url unless @user_member
    end

    def user_have_regular_member
      redirect_to root_url unless @group.user_is_regular_member?(@user_member)
    end

end
