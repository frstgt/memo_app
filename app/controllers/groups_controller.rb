class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_member,   only: [:members, :edit, :update, :destroy]
  before_action :master_or_vice,   only: [:edit, :update, :destroy]
  before_action :correct_pen_name, only: [:create]
  before_action :only_member,      only: [:destroy]

  def index
    @all_groups = Group.all
    @page_groups = @all_groups.paginate(page: params[:page])
  end

  def show
    @group = Group.find_by(id: params[:id])
    @all_notes = @group.group_notes
    @page_notes = @all_notes.paginate(page: params[:page])
  end

  def members
    @group = Group.find_by(id: params[:id])
    @leading_members = @group.leading_members    
    @general_members = @group.general_members.paginate(page: params[:page])    
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save

      @group.first_master(@pen_name)

      flash[:success] = "Group created"
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def update
    @group = current_user.groups.find(params[:id])
    if @group.update_attributes(group_params)
      flash[:success] = "Group updated"
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def destroy
    current_user.groups.find(params[:id]).destroy
    flash[:success] = "Group deleted"
    redirect_to current_user
  end

  private

    def group_params
      params.require(:group).permit(:name, :description, :picture, :pen_name_id)
    end

    def correct_member
      @group = Group.find_by(id: params[:id])
      redirect_to root_url unless @group.user_has_member?(current_user)
    end

    def correct_pen_name
      @pen_name = current_user.pen_names.find_by(id: params[:group][:pen_name_id])
      redirect_to root_url if @pen_name==nil
    end

    def master_or_vice
      redirect_to root_url unless @group.user_has_master_or_vice?(current_user)
    end

    def only_member
      redirect_to root_url unless @gourp.members.count == 1
    end

end
