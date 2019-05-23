class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :group_is_exist,             except: [:new, :create]
  before_action :user_have_member,           except: [:new, :create, :show, :join]

  before_action :user_can_show,                only: [:show]
  before_action :user_can_join,                only: [:join]
  before_action :user_can_unjoin,              only: [:unjoin]

  before_action :user_pen_name,                only: [:create, :join, :unjoin]

  before_action :user_have_leader,             only: [:change_leader]
  before_action :user_have_leading_member,     only: [:edit, :update, :destroy, :position]
  before_action :group_member,                 only: [:position]
  before_action :position_check,               only: [:position]

  before_action :user_have_only_member,        only: [:destroy]

  def show
    store_location

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
  end
  def create
    @group = Group.new(group_params)
    if @group.save

      @group.first_leader(@user_pen_name)

      flash[:success] = "Group created"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
  end
  def update
    if @group.update_attributes(group_params)
      flash[:success] = "Group updated"

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
    redirect_to current_user
  end

  #

  def join
    @group.join(@user_pen_name)
    redirect_to @group
  end
  def unjoin
    @group.unjoin(@user_pen_name)
    redirect_to current_user
  end

  def change_leader
    @group.change_leader
    redirect_to group_members_path(@group)
  end
  def position
    @group.set_position(@group_member, @to_pos)
    redirect_to group_members_path(@group)
  end

  private

    def group_params
      params.require(:group).permit(:name, :outline, :picture, :pen_name_id, :status)
    end

    def group_is_exist
      @group = Group.find_by(id: params[:id])
      redirect_to root_url unless @group
    end
    def user_have_member
      @user_member = @group.get_user_member(current_user)
      redirect_to root_url unless @user_member
    end

    def user_can_show
      redirect_to root_url unless @group.can_show?(current_user)
    end
    def user_can_join
      user_member = @group.get_user_member(current_user)
      redirect_to root_url unless (user_member == nil) and @group.is_joinus?
    end
    def user_can_unjoin
      redirect_to root_url if @group.is_leader?(@user_member)
    end

    def group_member
      @group_member = @group.members.find_by(id: params[:group][:pen_name_id])
      redirect_to root_url unless @group_member
    end
    def user_pen_name
      @user_pen_name = current_user.pen_names.find_by(id: params[:group][:pen_name_id])
      redirect_to root_url unless @user_pen_name
    end
    def position_check
      @do_pos = @group.get_position_id(@user_member)
      @from_pos = @group.get_position_id(@group_member)
      @to_pos = params[:group][:position].to_i
      @to_pos = Membership::POS_LEADER if @to_pos < Membership::POS_LEADER
      @to_pos = Membership::POS_VISITOR if @to_pos > Membership::POS_VISITOR
      unless @do_pos <= Membership::POS_SUBLEADER and @do_pos < @from_pos and @do_pos < @to_pos and @from_pos != @to_pos
          redirect_to root_url
      end
    end

    def user_have_leader
      redirect_to root_url unless @group.is_leader?(@user_member)
    end
    def user_have_leading_member
      redirect_to root_url unless @group.is_leading_member?(@user_member)
    end
    def user_have_only_member
      redirect_to root_url unless @group.is_leader?(@user_member) and @group.members.count == 1
    end

end
