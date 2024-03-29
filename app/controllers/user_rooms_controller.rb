class UserRoomsController < ApplicationController
  before_action :logged_in_user
  before_action :room_is_exist,   except: [:new, :create]

  before_action :user_can_show,     only: [:show]
  before_action :user_can_update,   only: [:edit, :update]
  before_action :user_can_destroy,  only: [:destroy]

  def show
    @message = @room.messages.build
    @all_messages = @room.messages
    @page_messages = @all_messages.paginate(page: params[:page])
  end

  def new
    @pen_names = current_user.pen_names
    @room = current_user.user_rooms.build
  end
  def create
    @pen_names = current_user.pen_names
    @room = current_user.user_rooms.build(room_params)
    if @room.save
      flash[:success] = "Room created"

      redirect_back_or(current_user)
    else
      render 'new'
    end
  end

  def edit
    @pen_names = current_user.pen_names
  end
  def update
    @pen_names = current_user.pen_names
    if @room.update_attributes(room_params)
      flash[:success] = "Room updated"
      redirect_to @room.redirect_path
    else
      render 'edit'
    end
  end

  def destroy
    @room.destroy
    flash[:success] = "Room deleted"

    redirect_back_or(current_user)
  end

  private

    def room_params
      params.require(:user_room).permit(:title, :outline, :pen_name_id, :picture, :status)
    end

    def room_is_exist
      @room = Room.find_by(id: params[:id])
      redirect_to root_url unless @room
    end

    def user_can_show
      redirect_to root_url unless @room.can_show?(current_user)
    end
    def user_can_update
      redirect_to root_url unless @room.can_update?(current_user)
    end
    def user_can_destroy
      redirect_to root_url unless @room.can_destroy?(current_user)
    end

end
