class PenNamesController < ApplicationController
  before_action :logged_in_user
  before_action :pen_name_is_exist, except: [:new, :create]

  before_action :user_can_show,       only: [:show]
  before_action :user_can_update,     only: [:edit, :update]
  before_action :user_can_destroy,    only: [:destroy]


  def show
    store_location

    if @pen_name.can_update?(current_user)
      @all_notes = @pen_name.user_notes
      @all_rooms = @pen_name.user_rooms
    else
      @all_notes = @pen_name.user_notes.where(status: Note::ST_OPEN)
      @all_rooms = @pen_name.user_rooms.where(status: Room::ST_OPEN)
    end
    @page_notes = @all_notes.paginate(page: params[:page])
    @page_rooms = @all_rooms.paginate(page: params[:page])
  end

  def new
    # this code is for avoiding a bug
    # build changes current_user.pen_names
    # and we should not access current_user.pen_names at that time
    # but memolet have PenName menu of the header
    # new does not changes current_user.pen_names
    # so we should use new at the situation

#    @pen_name = current_user.pen_names.build
    @pen_name = PenName.new
  end
  def create
    @pen_name = current_user.pen_names.build(pen_name_params)
    if @pen_name.save
      flash[:success] = "PenName created"
 
      redirect_to @pen_name
    else
      render 'new'
    end
  end

  def edit
  end
  def update
    if @pen_name.update_attributes(pen_name_params)
      flash[:success] = "PenName updated"
      
      unless @pen_name.is_open?
        @pen_name.groups.each do |group|
          if group.is_irregular_member?(@pen_name)
            group.unjoin(@pen_name)
          end
        end
      end

      redirect_to @pen_name
    else
      render 'edit'
    end
  end

  def destroy
    @pen_name.destroy
    flash[:success] = "PenName deleted"

    redirect_back_or(current_user)
  end
  
  private

    def pen_name_params
      params.require(:pen_name).permit(:name, :outline, :picture, :status, :keyword)
    end

    def pen_name_is_exist
      @pen_name = PenName.find_by(id: params[:id])
      redirect_to root_url if @pen_name.nil?
    end

    def user_can_show
      redirect_to root_url unless @pen_name.can_show?(current_user)
    end
    def user_can_update
      redirect_to root_url unless @pen_name.can_update?(current_user)
    end
    def user_can_destroy
      redirect_to root_url unless @pen_name.can_destroy?(current_user)
    end

end
