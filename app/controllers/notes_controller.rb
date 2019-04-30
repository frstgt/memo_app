class NotesController < ApplicationController
  before_action :logged_in_user

  def index
    @all_notes = Note.where(status: Note::ST_OPEN)
    @page_notes = @all_notes.paginate(page: params[:page])
    @sample_notes = @all_notes.sample(3)
  end

end
