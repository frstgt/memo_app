class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :group_is_exist,             except: [:new, :create, :index, :closed]
  before_action :user_have_member,           except: [:new, :create, :show, :join, :index, :closed]

  before_action :allowed_user,                 only: [:show, :join]

  before_action :user_have_general_member,     only: [:unjoin]
  before_action :user_have_leading_member,     only: [:position]
  before_action :user_have_core_member,        only: [:edit, :update, :destroy,
                                                      :to_open, :to_close]
  before_action :user_have_master,             only: [:change_master]

  before_action :user_pen_name,                only: [:create, :join, :unjoin]
  before_action :group_member,                 only: [:position]
  before_action :position_check1,              only: [:position]
  before_action :position_check2,              only: [:position]

  before_action :user_have_only_member,        only: [:destroy]

  def index
    @all_groups = Group.where(status: 1)
    @page_groups = @all_groups.paginate(page: params[:page])
    @sample_groups = @all_groups.sample(3)
  end

  def show
    @all_notes = @group.group_notes
    @page_notes = @all_notes.paginate(page: params[:page])
  end

  def members
    @leading_members = @group.leading_members    
    @general_members = @group.general_members.paginate(page: params[:page])    
  end

  def new
    @group = Group.new
  end
  def create
    @group = Group.new(group_params)
    if @group.save

      @group.first_master(@user_pen_name)

      flash[:success] = "Group created"
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
  end
  def update
    if @group.update_attributes(group_params)
      flash[:success] = "Group updated"
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

  def to_open
    @group.to_open
    redirect_to @group
  end
  def to_close
    @group.to_close
    @group.irregular_members.each do |visitor|
      @group.unjoin(visitor)
    end
    redirect_to @group
  end

  def join
    p params
    @group.join(@user_pen_name)
    redirect_to groups_path
  end
  def unjoin
    @group.unjoin(@user_pen_name)
    redirect_to groups_path
  end

  def change_master
    @group.change_master
    redirect_to members_group_path(@group)
  end
  def position
    @group.set_position(@group_member, @to_pos)
    redirect_to members_group_path(@group)
  end

  private

    def group_params
      params.require(:group).permit(:name, :description, :picture, :pen_name_id)
    end

    def group_is_exist
      @group = Group.find_by(id: params[:id])
      redirect_to root_url unless @group
    end
    def user_have_member
      @user_member = @group.get_user_member(current_user)
      redirect_to root_url unless @user_member
    end

    def allowed_user
      unless @group and (@group.get_user_member(current_user) or @group.is_open?)
        redirect_to root_url
      end
    end

    def group_member
      @group_member = @group.members.find_by(id: params[:group][:pen_name_id])
      redirect_to root_url unless @group_member
    end
    def user_pen_name
      @user_pen_name = current_user.pen_names.find_by(id: params[:group][:pen_name_id])
      redirect_to root_url unless @user_pen_name
    end
    def position_check1
      @do_pos = @group.get_position_id(@user_member)
      @from_pos = @group.get_position_id(@group_member)
      @to_pos = params[:group][:position].to_i
      @to_pos = Membership::MASTER if @to_pos < Membership::MASTER
      @to_pos = Membership::VISITOR if @to_pos > Membership::VISITOR
      unless @do_pos <= Membership::CHIEF and @do_pos < @from_pos and @do_pos < @to_pos and @from_pos != @to_pos
          redirect_to root_url
      end
    end
    def position_check2
      unless @to_pos == Membership::VICE and @group.core_members.count < 3
        redirect_to members_group_path(@group)
      end
    end

    def user_have_master
      redirect_to root_url unless @group.is_master?(@user_member)
    end
    def user_have_core_member
      redirect_to root_url unless @group.is_core_member?(@user_member)
    end
    def user_have_leading_member
      redirect_to root_url unless @group.is_leading_member?(@user_member)
    end
    def user_have_general_member
      redirect_to root_url unless @group.is_general_member?(@user_member)
    end

    def user_have_only_member
      redirect_to root_url unless @group.is_master?(@user_member) and @gourp.members.count == 1
    end

end
