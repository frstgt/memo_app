class GroupMemosController < GroupBaseController
  before_action :note_is_exist
  before_action :user_have_member

  before_action :memo_is_exist,          except: [:new, :create]
  before_action :user_have_regular_member, only: [:new, :create, :edit, :update, :destroy]

  def new
    @memo = @note.group_memos.build
    @max = @value = @note.group_memos.count + 1
  end
  def create
    @memo = @note.group_memos.build(memo_params)
    if @memo.save

      update_number(@note.group_memos, @memo)

      flash[:success] = "GroupMemo created"
      redirect_to group_group_note_path(@group, @note)
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

      flash[:success] = "GroupMemo updated"
      redirect_to group_group_note_path(@group, @note)
    else
      render 'edit'
    end
  end

  def destroy
    @note.group_memos.find(params[:id]).destroy
    flash[:success] = "GroupMemo deleted"
    redirect_to group_group_note_path(@group, @note)
  end

  private

    def memo_params
      params.require(:group_memo).permit(:title, :content, :number)
    end

    def note_is_exist
      @note = @group.group_notes.find_by(id: params[:group_note_id])
      redirect_to root_url unless @note
    end
    def memo_is_exist
      @memo = @note.group_memos.find_by(id: params[:id])
      redirect_to root_url unless @memo
    end

end
