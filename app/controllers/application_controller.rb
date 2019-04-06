class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def update_number(ones, new_one)
      if new_one.number < 1 then
        new_one.update_attributes({number: 1})
      elsif new_one.number > ones.count then
        new_one.update_attributes({number: ones.count })
      end

      new_number = new_one.number + 1
      for one in ones do
        if one != new_one and one.number >= new_one.number then
          one.update_attributes({number: new_number})
          new_number += 1
        end
      end
    end

end
