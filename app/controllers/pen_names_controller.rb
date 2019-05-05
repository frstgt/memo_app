class PenNamesController < ApplicationController
  before_action :logged_in_user
  before_action :pen_name_is_exist, except: [:index, :new, :create]
  before_action :correct_user,      except: [:index, :new, :create, :show]

  before_action :allowed_user,        only: [:show]

  def index
    @all_pen_names = PenName.where(status: PenName::ST_OPEN)
    @page_pen_names = @all_pen_names.paginate(page: params[:page])
    @sample_pen_names = @all_pen_names.sample(3)
  end

  def show
    store_location

    if @pen_name.user == current_user
      @all_notes = @pen_name.user_notes
    else
      @all_notes = @pen_name.user_notes.where(status: Note::ST_OPEN)
    end
    @page_notes = @all_notes.paginate(page: params[:page])
    @groups = @pen_name.groups
  end

  def new
    @pen_name = current_user.pen_names.build
  end
  def create
    @pen_name = current_user.pen_names.build(pen_name_params)
    if @pen_name.save
      flash[:success] = "PenName created"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
  end
  def update
    if @pen_name.update_attributes(pen_name_params)
      flash[:success] = "PenName updated"
      redirect_to @pen_name
    else
      render 'edit'
    end
  end

  def destroy
    @pen_name.destroy
    flash[:success] = "PenName deleted"
    redirect_to current_user
  end

  def to_open
    @pen_name.to_open
    redirect_to @pen_name
  end
  def to_close
    @pen_name.to_close
    @pen_name.groups.each do |group|
      if group.is_regular_member?(@pen_name)
        group.unjoin(@pen_name)
      end
    end
    redirect_to @pen_name
  end
  
  private

    def pen_name_params
      params.require(:pen_name).permit(:name, :description, :picture)
    end

    def pen_name_is_exist
      @pen_name = PenName.find_by(id: params[:id])
      redirect_to root_url if @pen_name.nil?
    end

    def allowed_user
      @pen_name = PenName.find_by(id: params[:id])
      unless @pen_name and (current_user.pen_names.include?(@pen_name) or @pen_name.is_open?)
        redirect_to root_url
      end
    end

    def correct_user
      @pen_name = current_user.pen_names.find_by(id: params[:id])
      redirect_to root_url if @pen_name.nil?
    end

end
