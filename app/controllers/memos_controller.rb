class MemosController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :correct_note,  only: [:edit, :update, :destroy]

  def new
    @memo = @note.memos.build
  end

  def create
    @memo = @note.memos.build(memo_params)
    if @memo.save
      flash[:success] = "Memo created"
      redirect_to @note
    else
      render 'new'
    end
  end

  def edit
    @memo = @note.memos.find(params[:id])
  end

  def update
    @memo = @note.memos.find(params[:id])
    if @memo.update_attributes(memo_params)
      flash[:success] = "Memo updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.memos.find(params[:id]).destroy
    flash[:success] = "Memo deleted"
    redirect_to @note
  end

  private

    def memo_params
      params.require(:memo).permit(:content, :picture)
    end

    def correct_user
      @note = current_user.notes.find_by(id: params[:note_id])
      redirect_to root_url if @note.nil?
    end

    def correct_note
      @memo = @note.memos.find_by(id: params[:id])
      redirect_to root_url if @memo.nil?
    end

end
