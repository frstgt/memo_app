class NotesController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist,   only: [:set_point, :to_open, :to_close]
  before_action :user_can_setup,  only: [:to_open, :to_close]

  def index
    store_location

    case params[:mode]
    when "pos"
      @all_notes = Note.positive_list(current_user).where(status: Note::ST_OPEN)
    when "neg"
      @all_notes = Note.negative_list(current_user).where(status: Note::ST_OPEN)
    else
      @all_notes = Note.non_negative_list(current_user).where(status: Note::ST_OPEN)
    end

    @page_notes = @all_notes.paginate(page: params[:page])
    @sample_notes = @all_notes.sample(3)
  end

  def to_open
    @note.to_open
    redirect_to @note.redirect_path
  end
  def to_close
    @note.to_close
    redirect_to @note.redirect_path
  end

  def set_point
    point = (params[:note][:point]).to_i
    point = -5 if point < -5
    point = 5 if point > 5

    @note.set_point(current_user, point)

    redirect_back_or(notes_path)
  end

  private

    def note_is_exist
      @note = Note.find_by(id: params[:id])
      redirect_to root_url unless @note
    end

    def user_can_setup
      redirect_to root_url unless @note.can_setup?(current_user)
    end
  
end
