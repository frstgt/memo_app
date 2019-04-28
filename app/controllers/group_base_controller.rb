class GroupBaseController < ApplicationController
  
  # for group_notes, group_memos, group_pictures
  
  before_action :logged_in_user
  before_action :group_is_exist

  private

    def group_is_exist
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group
    end

    def user_have_member
      @user_member = @group.get_user_member(current_user)
      redirect_to root_url unless @user_member
    end
    def user_have_leading_member
      redirect_to root_url unless @group.is_leading_member?(@user_member)
    end
    def user_have_regular_member
      redirect_to root_url unless @group.is_regular_member?(@user_member)
    end
    
end