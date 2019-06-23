class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :group_is_exist,             except: [:new, :create]

  before_action :user_can_show,                only: [:show]
  before_action :user_can_create,              only: [:create]
  before_action :user_can_edit,                only: [:edit]
  before_action :user_can_update,              only: [:update]
  before_action :user_can_destroy,             only: [:destroy]

  before_action :user_can_join,                only: [:join]
  before_action :user_can_unjoin,              only: [:unjoin]
  before_action :user_can_change_leader,       only: [:change_leader]
  before_action :user_can_set_position,        only: [:position]

  def show
    pen_name = @group.get_user_member(current_user)
    if pen_name and @group.is_regular_member?(pen_name)
      @all_notes = @group.group_notes
      @all_rooms = @group.group_rooms
    else
      @all_notes = @group.group_notes.where(status: Note::ST_OPEN)
      @all_rooms = @group.group_rooms.where(status: Note::ST_OPEN)
    end
    @page_notes = @all_notes.paginate(page: params[:page])
    @page_rooms = @all_rooms.paginate(page: params[:page])
  end

  def new
    @group = Group.new
    @members = current_user.pen_names
  end
  def create
    @group = Group.new(group_params)
    if @group.save

      @group.set_leader(@leader)

      flash[:success] = "Group created"
      
      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
    @members = @group.regular_members
  end
  def update
    if @group.update_attributes(group_params)
      flash[:success] = "Group updated"

      @group.set_leader(@leader)

      unless @group.is_open?
        @group.irregular_members.each do |member|
          @group.unjoin(member)
        end
      end

      redirect_to @group
    else
      render 'edit'
    end
  end

  def destroy
    @group.destroy
    flash[:success] = "Group deleted"

    redirect_back_or(current_user)
  end

  #

  def join
    @group.join(@user_pen_name)
    redirect_to @group
  end
  def unjoin
    user_member = @group.get_user_member(current_user)
    @group.unjoin(user_member)
    redirect_to current_user
  end

  def position
    @group.set_position(@group_member, @to_pos)
    redirect_to group_members_path(@group)
  end

  private

    def group_params
      params.require(:group).permit(:name, :outline, :picture, :leader_id, :status, :keyword)
    end

    def group_is_exist
      @group = Group.find_by(id: params[:id])
      redirect_to root_url unless @group
    end

    def user_can_show
      redirect_to root_url unless @group.can_show?(current_user)
    end
    def user_can_create
      @leader = current_user.pen_names.find_by(id: params[:group][:leader_id])
      redirect_to root_url unless @leader
    end
    def user_can_edit
      redirect_to root_url unless @group.can_update?(current_user)
    end
    def user_can_update
      @leader = @group.regular_members.find_by(id: params[:group][:leader_id])
      redirect_to root_url unless @leader and @group.can_update?(current_user)
    end
    def user_can_destroy
      redirect_to root_url unless @group.can_destroy?(current_user)
    end
    def user_can_join
      @user_pen_name = current_user.pen_names.find_by(id: params[:group][:pen_name_id])
      redirect_to root_url unless @user_pen_name and @group.can_join?(current_user)
    end
    def user_can_unjoin
      redirect_to root_url unless @group.can_unjoin?(current_user)
    end
    def user_can_change_leader
      redirect_to root_url unless @group.can_change_leader?(current_user)
    end
    def user_can_set_position
      @group_member = @group.members.find_by(id: params[:group][:pen_name_id])
      @to_pos = params[:group][:position].to_i
      @to_pos = Membership::POS_LEADER if @to_pos < Membership::POS_LEADER
      @to_pos = Membership::POS_VISITOR if @to_pos > Membership::POS_VISITOR
      redirect_to root_url unless @group_member and @group.can_set_position?(current_user, @group_member, @to_pos)
    end

end
