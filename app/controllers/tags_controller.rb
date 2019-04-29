class TagsController < ApplicationController
  before_action :logged_in_user
  before_action :tag_is_exist

  def show
    @all_notes = @tag.notes #.where(status: Note::ST_OPEN)
    @page_notes = @all_notes.paginate(page: params[:page])
  end
  
  private

    def tag_is_exist
      @tag = Tag.find_by(id: params[:id])
      redirect_to root_url unless @tag
    end
  
end