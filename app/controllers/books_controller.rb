class BooksController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,  only: [:show]

  def show
    @user = current_user
    @book = current_user.books.find(params[:id])
    @pages = @book.pages.paginate(page: params[:page])
  end

  def new
    @book = current_user.books.build
  end

  def create
    @book = current_user.books.build(note_params)
    if @book.save
      flash[:success] = "Book created"
      redirect_to current_user
    else
      render 'new'
    end
  end

  private

    def book_params
      params.require(:book).permit(:title, :author, :description, :pen_name_id)
    end

    def correct_user
      @book = current_user.books.find_by(id: params[:id])
      redirect_to root_url if @book.nil?
    end

end
