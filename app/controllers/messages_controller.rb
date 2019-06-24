class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :room_is_exist
  before_action :pen_name_is_exist

  def create
    @message = @room.messages.build(message_params)
    if @message.save
      flash[:success] = "Message created"
    end
    redirect_to @room.redirect_path
  end

  private

    def message_params
      params.require(:message).permit(:content, :pen_name_id)
    end

    def room_is_exist
      @room = Room.find_by(id: params[:room_id])
      redirect_to root_url unless @room and @room.can_control_messages?(current_user)
    end
    def pen_name_is_exist
      @pen_name = PenName.find_by(id: params[:message][:pen_name_id])
      last_pen_name = @room.get_user_pen_name(current_user)
      c1 = (@pen_name and @pen_name.user == current_user)
      c2 = (last_pen_name == nil) or (last_pen_name and last_pen_name == @pen_name)
      redirect_to root_url unless c1 and c2
    end

end
