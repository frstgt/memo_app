class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def params2d(key1, key2)
      (params[key1]) ? params[key1][key2] : nil
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def insert_one(ones, new_one)
      if new_one.number < 1 then
        new_one.update_attributes({number: 1})
      elsif new_one.number > ones.count then
        new_one.update_attributes({number: ones.count })
      end

      new_number = 1
      for one in ones do
        if one != new_one
          if new_number == new_one.number
            new_number += 1
          end
          if new_number != one.number
            one.update_attributes({number: new_number})
          end
          new_number += 1
        end
      end
    end

    def delete_one(ones)
      new_number = 1
      for one in ones do
        if new_number != one.number
          one.update_attributes({number: new_number})
        end
        new_number += 1
      end
    end

end
