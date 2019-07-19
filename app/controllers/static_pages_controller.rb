class StaticPagesController < ApplicationController
  def home
    @all_notes = Note.where(status: Note::ST_WEB)
    @page_notes = @all_notes.paginate(page: params[:page])
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
