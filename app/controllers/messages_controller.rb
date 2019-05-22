class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :room_is_exist

  def create
    params[:message][:pen_name_id] = @user_member.id
    @message = @group.messages.build(message_params)
    if @message.save
      flash[:success] = "Message created"
      redirect_to @room.redirect_path
    else
      render 'rooms/show'
    end
  end

  private

    def message_params
      params.require(:message).permit(:content, :pen_name_id)
    end

    def room_is_exist
      @room = Room.find_by(id: params[:room_id])
      redirect_to root_url unless @room and @room.can_control_messages?(current_user)
    end

    def user_have_member
      @user_member = @group.get_user_member(current_user)
      redirect_to root_url unless @user_member
    end

end
