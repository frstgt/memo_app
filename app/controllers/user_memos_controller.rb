class UserMemosController < MemosController
  before_action :correct_note
  before_action :correct_memo,  only: [:edit, :update, :destroy]

  def new
    @memo = @note.user_memos.build
    @max = @value = @note.user_memos.count + 1
  end

  def create
    @memo = @note.user_memos.build(memo_params)
    if @memo.save

      update_number(@note.user_memos, @memo)

      flash[:success] = "Memo created"
      redirect_to @note
    else
      render 'new'
    end
  end

  def edit
    @memo = @note.user_memos.find(params[:id])
    @max = @note.user_memos.count + 1
    @value = @memo.number
  end

  def update
    @memo = @note.user_memos.find(params[:id])
    if @memo.update_attributes(memo_params)

      update_number(@note.user_memos, @memo)

      flash[:success] = "Memo updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.user_memos.find(params[:id]).destroy
    flash[:success] = "Memo deleted"
    redirect_to @note
  end

  private

    def memo_params
      params.require(:user_memo).permit(:title, :content, :picture, :number)
    end

    def correct_note
      @note = current_user.user_notes.find_by(id: params[:user_note_id])
      p @note
      redirect_to root_url if @note.nil?
    end

    def correct_memo
      @memo = @note.user_memos.find_by(id: params[:id])
      p @memo
      redirect_to root_url if @memo.nil?
    end

end
