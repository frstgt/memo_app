class UserNotesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,  only: [:show, :edit, :update, :destroy, :to_book]

  def show
    @note = current_user.user_notes.find(params[:id])
    @all_memos = @note.user_memos
    @page_memos = @all_memos.paginate(page: params[:page])
  end

  def new
    @note = current_user.user_notes.build
  end
  def create
    @note = current_user.user_notes.build(note_params)
    if @note.save
      flash[:success] = "Note created"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
    @note = current_user.user_notes.find(params[:id])
  end
  def update
    @note = current_user.user_notes.find(params[:id])
    if @note.update_attributes(note_params)
      flash[:success] = "Note updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    current_user.user_notes.find(params[:id]).destroy
    flash[:success] = "Note deleted"
    redirect_to current_user
  end

  #

  def to_book
    if @note.to_book
      flash[:success] = "Book published"
    end
    redirect_to @note
  end

  private

    def note_params
      params.require(:user_note).permit(:title, :description, :pen_name_id, :picture)
    end

    def correct_user
      @note = current_user.user_notes.find_by(id: params[:id])
      redirect_to root_url if @note.nil?
    end

end
