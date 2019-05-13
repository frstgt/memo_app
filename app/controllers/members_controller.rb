class MembersController < ApplicationController
  before_action :logged_in_user
  before_action :group_is_exist,   only: [:index]
  before_action :user_have_member, only: [:index]

  def index
    @all_members = @group.members    
    @page_members = @all_members.paginate(page: params[:page]) 
  end

  private

    def group_is_exist
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group
    end

    def user_have_member
      @user_member = @group.get_user_member(current_user)
      redirect_to root_url unless @user_member
    end

end
