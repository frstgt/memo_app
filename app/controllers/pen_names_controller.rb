class PenNamesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,  only: [:show, :edit, :update, :destroy]

  def show
    @pen_name = current_user.pen_names.find(params[:id])
    @notes = @pen_name.notes
    @groups = @pen_name.groups.paginate(page: params[:page])
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
    @pen_name = current_user.pen_names.find(params[:id])
  end

  def update
    @pen_name = current_user.pen_names.find(params[:id])
    if @pen_name.update_attributes(pen_name_params)
      flash[:success] = "PenName updated"
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def destroy
    current_user.pen_names.find(params[:id]).destroy
    flash[:success] = "PenName deleted"
    redirect_to current_user
  end
  
  private

    def pen_name_params
      params.require(:pen_name).permit(:name, :description)
    end

    def correct_user
      @pen_name = current_user.pen_names.find_by(id: params[:id])
      redirect_to root_url if @pen_name.nil?
    end

end
