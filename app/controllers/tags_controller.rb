class TagsController < ApplicationController
  before_action :tag_is_exist

  def show
    store_location

    if current_user
      @all_notes = @tag.notes.where(["status = ? or status = ?", Note::ST_OPEN, Note::ST_WEB])
    else
      @all_notes = @tag.notes.where(status: Note::ST_WEB)
    end
    @page_notes = @all_notes.paginate(page: params[:page])
    @sample_notes = @all_notes.sample(3)
  end
  
  private

    def tag_is_exist
      @tag = Tag.find_by(id: params[:id])
      redirect_to root_url unless @tag
    end
  
end