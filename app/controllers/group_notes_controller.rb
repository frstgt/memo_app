class GroupNotesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_member
  before_action :master_or_vice_or_chief,                      only: [:new, :create, :destroy, :to_book]
  before_action :master_or_vice_or_chief_or_common,            only: [:edit, :update]

  def show
    @note = @group.group_notes.find(params[:id])
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

  def to_book
    if @note.to_book
      flash[:success] = "Book published"
    end
    redirect_to @group
  end

  private

    def note_params
      params.require(:group_note).permit(:title, :description, :pen_name_id, :picture)
    end

    def correct_member
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group.user_has_member?(current_user)
    end

    def master_or_vice_or_chief
      redirect_to root_url unless @group.user_has_master_or_vice_or_chief?(current_user)
    end
    def master_or_vice_or_chief_or_common
      redirect_to root_url unless @group.user_has_master_or_vice_or_chief_or_common?(current_user)
    end

end
