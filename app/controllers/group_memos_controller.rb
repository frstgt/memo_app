class GroupMemosController < MemosController
  before_action :correct_member
  before_action :correct_note
  before_action :correct_memo,                      only: [:edit, :update, :destroy]
  before_action :master_or_vice_or_chief_or_common, only: [:edit, :update, :destroy]

  def new
    @memo = @memo.group_memos.build
    @url = new_group_gnote_gmemo_path(@group, @note, @memo)
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
    @url = edit_group_gnote_gmemo_path(@group, @note, @memo)
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

    def correct_member
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group.user_has_member?(current_user)
    end

    def correct_note
      @note = @group.group_notes.find_by(id: :group_note_id)      
      redirect_to root_url if @note.nil?
    end

    def correct_memo
      @memo = @note.memos.find_by(id: params[:id])
      redirect_to root_url if @memo.nil?
    end

    def master_or_vice_or_chief_or_common
      redirect_to root_url unless @group.user_has_master_or_vice_or_chief_or_common?(current_user)
    end

end
