class UserNotesController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist,  except: [:new, :create]
  before_action :correct_user,   except: [:show, :new, :create]

  before_action :allowed_user,     only: [:show]

  def show
    @pictures = @note.user_pictures
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

      @note.save_tag_list

      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
    @note = current_user.user_notes.find(params[:id])
    @note.load_tag_list
  end
  def update
    @note = current_user.user_notes.find(params[:id])
    if @note.update_attributes(note_params)
      flash[:success] = "Note updated"

      @note.save_tag_list

      redirect_to user_note_path(@note)
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

  def to_open
    @note.to_open
    redirect_to user_note_path(@note)
  end
  def to_close
    @note.to_close
    redirect_to user_note_path(@note)
  end

  private

    def note_params
      params.require(:user_note).permit(:title, :description, :pen_name_id, :picture, :tag_list)
    end

    def note_is_exist
      @note = UserNote.find_by(id: params[:id])
      redirect_to root_url unless @note
    end

    def correct_user
      unless @note.user == current_user
        redirect_to root_url
      end
    end

    def allowed_user
      unless (@note.user == current_user) or @note.is_open?
        redirect_to root_url
      end
    end

end
