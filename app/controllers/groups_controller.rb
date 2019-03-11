class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :allowed_user,       only: [:show, :join]

  before_action :correct_member,     only: [:members, :edit, :update, :destroy]
  before_action :common_or_visitor,  only: [:unjoin]
  before_action :master_or_vice,     only: [:edit, :update, :destroy, :to_open, :to_close, :position]

  before_action :correct_pen_name,   only: [:create, :join, :unjoin]
  before_action :only_member,        only: [:destroy]

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

      @group.join(@pen_name, Memberships::MASTER)

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
    redirect_to @group
  end

  def join
    @group.join(@pen_name)
    redirect_to groups_path
  end
  def unjoin
    @group.unjoin(@pen_name)
    redirect_to groups_path
  end
  def position
    @pen_name = @group.members.find_by(id: params[:group][:pen_name_id])
    @position = params[:group][:position]
    @group.set_position(@pen_name, @position)
    redirect_to members_group_path(@group)
  end

  private

    def group_params
      params.require(:group).permit(:name, :description, :picture, :pen_name_id)
    end

    def allowed_user
      @group = Group.find_by(id: params[:id])
      unless @group and (@group.has_member?(current_user) or @group.is_open?)
        redirect_to root_url
      end
    end

    def correct_pen_name
      @pen_name = current_user.pen_names.find_by(id: params[:group][:pen_name_id])
      redirect_to root_url if @pen_name==nil
    end

    def correct_member
      @group = Group.find_by(id: params[:id])
      redirect_to root_url unless @group.has_member?(current_user)
    end
    def master_or_vice
      @group = Group.find_by(id: params[:id])
      redirect_to root_url unless @group.has_master_or_vice?(current_user)
    end
    def common_or_visitor
      @group = Group.find_by(id: params[:id])
      redirect_to root_url if @group.has_master_or_vice_or_chief?(current_user)
    end

    def only_member
      @group = Group.find_by(id: params[:id])
      redirect_to root_url unless @gourp.members.count == 1
    end

end
