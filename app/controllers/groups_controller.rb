class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_member,  only: [:show, :edit, :update, :destroy]

  def show
    @group = Group.find_by(id: params[:id])
    @leading_members = @group.leading_members
  end
  def members
    @group = Group.find_by(id: params[:id])
    @leading_members = @group.leading_members    
    @general_members = @group.general_members.paginate(page: params[:page])    
  end

  private

    def note_params
      params.require(:note).permit(:title, :description, :pen_name_id, :picture)
    end

    def correct_member
      @group = Group.find_by(id: params[:id])
      redirect_to root_url unless @group.user_has_member?(current_user)
    end

end
