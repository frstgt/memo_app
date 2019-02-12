class MemosController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :correct_note,  only: [:edit, :update, :destroy]

  def new
    @memo = @note.memos.build
    @max = @value = @note.memos.count + 1
  end

  def create
    @memo = @note.memos.build(memo_params)
    if @memo.save

      update_number(@note.memos, @memo)

      flash[:success] = "Memo created"
      redirect_to @note
    else
      render 'new'
    end
  end

  def edit
    @memo = @note.memos.find(params[:id])
    @max = @note.memos.count + 1
    @value = @memo.number
  end

  def update
    @memo = @note.memos.find(params[:id])
    if @memo.update_attributes(memo_params)

      update_number(@note.memos, @memo)

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
      params.require(:memo).permit(:content, :picture, :number)
    end

    def correct_user
      @note = current_user.notes.find_by(id: params[:note_id])
      redirect_to root_url if @note.nil?
    end

    def correct_note
      @memo = @note.memos.find_by(id: params[:id])
      redirect_to root_url if @memo.nil?
    end

    def update_number(memos, new_memo)
      if new_memo.number < 1 then
        new_memo.update_attributes({number: 1})
      elsif new_memo.number > memos.count then
        new_memo.update_attributes({number: memos.count })
      end

      new_number = new_memo.number + 1
      for memo in memos do
        if memo != new_memo and memo.number >= new_memo.number then
          memo.update_attributes({number: new_number})
          new_number += 1
        end
      end
    end

end
