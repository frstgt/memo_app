class BooksController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :evaluate]

  def index
    @all_books = Book.all
    @page_books = @all_books.paginate(page: params[:page])
    @sample_books = @all_books.sample(3)
  end

  def show
    @book =  Book.find_by(id: params[:id])
    @pages = @book.pages.paginate(page: params[:page])
  end

  def evaluate
    @book =  Book.find_by(id: params[:id])
    if @book
      @evaluation = params[:book][:evaluation].to_i
      @evaluation = 5 if @evaluation > 5
      @evaluation = -5 if @evaluation < -5
      @book.set_evaluation(current_user, @evaluation)
    end
    redirect_to books_path
  end

end
