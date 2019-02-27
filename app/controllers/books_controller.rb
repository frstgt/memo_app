class BooksController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]

  def index
    @all_books = Book.all
    @page_books = @all_books.paginate(page: params[:page])
  end

  def show
    @book =  Book.find_by(id: params[:id])
    @pages = @book.pages.paginate(page: params[:page])
  end

end
