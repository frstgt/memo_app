class PenNamesController < ApplicationController
  before_action :logged_in_user
  before_action :allowed_user,     only: [:show]
  before_action :correct_user,     only: [:edit, :update, :destroy, :to_open, :to_close]

  def index
    @all_pen_names = PenName.where(status: 1)
    @page_pen_names = @all_pen_names.paginate(page: params[:page])
    @sample_pen_names = @all_pen_names.sample(3)
  end

  def show
    @all_books = @pen_name.books
    @page_books = @all_books.paginate(page: params[:page])
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
    redirect_to @pen_name
  end
  
  private

    def pen_name_params
      params.require(:pen_name).permit(:name, :description, :picture)
    end

    def allowed_user
      @pen_name = PenName.find_by(id: params[:id])
      unless @pen_name and (current_user.pen_names.include?(@pen_name) or @pen_name.is_open?)
        redirect_to root_url
      end
    end

    def correct_user
      @pen_name = current_user.pen_names.find_by(id: params[:id])
      redirect_to if @pen_name.nil?
    end

end
