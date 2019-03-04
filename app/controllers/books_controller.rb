class BooksController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :evaluate, :evaluations]

  def index
    @all_books = Book.all
    @page_books = @all_books.paginate(page: params[:page])
    @sample_books = @all_books.sample(3)
  end

  def show
    @book =  Book.find_by(id: params[:id])
    @pages = @book.pages.paginate(page: params[:page])
  end

  def evaluations
    @book =  Book.find_by(id: params[:id])
    @evaluations = Readership::EVALUATIONS
  end
  def evaluate
    @book =  Book.find_by(id: params[:id])
    @book.evaluate(current_user, params[:evaluation])
    redirect_to books_path
  end

end
