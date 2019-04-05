class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :group_is_exist
  before_action :user_have_member

  def create
    @message = @group.messages.build(message_params)
    if @message.save
      flash[:success] = "Message created"
      redirect_to messages_group_path(@group)
    else
      render 'groups/messages'
    end
  end

  private

    def message_params
      params.require(:message).permit(:content, :pen_name_id)
    end

    def group_is_exist
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group
    end

    def user_have_member
      @user_member = @group.get_user_member(current_user)
      redirect_to root_url unless @user_member
    end

end
