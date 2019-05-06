class RoomsController < ApplicationController
  before_action :logged_in_user
  before_action :group_is_exist
  before_action :room_is_exist,     except: [:new, :create]

  before_action :user_can_show,       only: [:show]
  before_action :user_can_create,     only: [:new, :create]
  before_action :user_can_update,     only: [:edit, :update]
  before_action :user_can_destroy,    only: [:destroy]

  def show
    @message = @room.messages.build
    @all_messages = @room.messages
    @page_messages = @all_messages.paginate(page: params[:page])
  end

  def new
    @room = @group.rooms.build
  end
  def create
    @room = @group.rooms.build(room_params)
    if @room.save
      flash[:success] = "Room created"
      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
  end
  def update
    if @room.update_attributes(room_params)
      flash[:success] = "Room updated"
      redirect_to group_room_path(@group, @room)
    else
      render 'edit'
    end
  end

  def destroy
    @root.destroy
    flash[:success] = "Root deleted"
    redirect_to @group
  end

  private

    def room_params
      params.require(:room).permit(:title, :outline, :picture)
    end

    def group_is_exist
      @group = Group.find_by(id: params[:group_id])
      redirect_to root_url unless @group
    end
    def room_is_exist
      @room = Room.find_by(id: params[:id])
      redirect_to root_url unless @room
    end

    def user_can_show
      redirect_to root_url unless @room.can_show?(current_user)
    end
    def user_can_create
      member = @group.get_user_member(current_user)
      redirect_to root_url unless member and @group.is_leading_member?(member)
    end
    def user_can_update
      redirect_to root_url unless @room.can_update?(current_user)
    end
    def user_can_destroy
      redirect_to root_url unless @room.can_destroy?(current_user)
    end
  
end
