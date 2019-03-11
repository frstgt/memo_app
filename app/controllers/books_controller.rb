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
      if @evaluation > 3
        @evaluation = 3
      elsif @evaluation < -1
        @evaluation = -1
      end
      @book.set_evaluation(current_user, @evaluation)
    end
    redirect_to books_path
  end

end
