class MemosController < ApplicationController

  private

    def update_number(memos, new_memo)
      if new_memo.number < 1 then
        new_memo.update_attributes({number: 1})
      elsif new_memo.number > memos.count then
        new_memo.update_attributes({number: memos.count })
      end

      new_number = new_memo.number + 1
      for memo in memos do
        if memo != new_memo and memo.number >= new_memo.number then
          memo.update_attributes({number: new_number})
          new_number += 1
        end
      end
    end

end
