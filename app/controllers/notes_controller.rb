class NotesController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist,      only: [:set_point]
  before_action :user_can_set_point, only: [:set_point]

  def index
    case params[:mode]
    when "favorite"
      @all_notes = Note.positive_list(current_user).where(["status = ? or status = ?", Note::ST_OPEN, Note::ST_WEB])
    when "disliked"
      @all_notes = Note.negative_list(current_user).where(["status = ? or status = ?", Note::ST_OPEN, Note::ST_WEB])
    else
      @all_notes = Note.non_negative_list(current_user).where(["status = ? or status = ?", Note::ST_OPEN, Note::ST_WEB])
    end

    @page_notes = @all_notes.paginate(page: params[:page])
    @sample_notes = @all_notes.sample(3)
  end

  def set_point
    point = (params2d(:note, :point)).to_i
    point = -5 if point < -5
    point = 5 if point > 5

    @note.set_point(current_user, point)

    redirect_to @note.redirect_path
  end

  private

    def note_is_exist
      @note = Note.find_by(id: params[:id])
      redirect_to root_url unless @note
    end

    def user_can_set_point
      redirect_to root_url unless @note.can_set_point?(current_user)
    end

end
