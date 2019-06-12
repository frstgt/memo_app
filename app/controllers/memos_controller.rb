class MemosController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist
  before_action :memo_is_exist,  except: [:new, :create]

  def new
    @memo = @note.memos.build
    @max = @note.memos.count + 1
    if @note.add_first?
      @value = 1
    else
      @value = @note.memos.count + 1
    end
  end
  def create
    @memo = @note.memos.build(memo_params)
    if @memo.save

      insert_one(@note.memos, @memo)

      flash[:success] = "Memo created"

      redirect_to @note.redirect_path
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

      insert_one(@note.memos, @memo)

      flash[:success] = "Memo updated"

      redirect_to @note.redirect_path
    else
      render 'edit'
    end
  end

  def destroy
    @note.memos.find(params[:id]).destroy
    flash[:success] = "Memo deleted"

    delete_one(@note.memos)

    redirect_to @note.redirect_path
  end

  private

    def memo_params
      params.require(:memo).permit(:title, :content, :number)
    end

    def note_is_exist
      @note = Note.find_by(id: params[:note_id])
      redirect_to root_url unless @note and @note.can_control_memos?(current_user)
    end

    def memo_is_exist
      @memo = @note.memos.find_by(id: params[:id])
      redirect_to root_url if @memo.nil?
    end

end
