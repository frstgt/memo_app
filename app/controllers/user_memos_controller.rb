class UserMemosController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist
  before_action :memo_is_exist,  only: [:edit, :update, :destroy]

  def new
    @memo = @note.user_memos.build
    @max = @value = @note.user_memos.count + 1
  end

  def create
    @memo = @note.user_memos.build(memo_params)
    if @memo.save

      update_number(@note.user_memos, @memo)

      flash[:success] = "UserMemo created"
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

      flash[:success] = "UserMemo updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.user_memos.find(params[:id]).destroy
    flash[:success] = "UserMemo deleted"
    redirect_to @note
  end

  private

    def memo_params
      params.require(:user_memo).permit(:title, :content, :number)
    end

    def note_is_exist
      @note = current_user.user_notes.find_by(id: params[:user_note_id])
      redirect_to root_url if @note.nil?
    end

    def memo_is_exist
      @memo = @note.user_memos.find_by(id: params[:id])
      redirect_to root_url if @memo.nil?
    end

end
