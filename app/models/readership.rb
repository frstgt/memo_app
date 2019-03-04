class Readership < ApplicationRecord
  belongs_to :reader, class_name: "User"
  belongs_to :book, class_name: "Book"
  
  validates :reader_id, presence: true
  validates :book_id,  presence: true

  EVALUATIONS = [
    ["I will check later.", 0],

    ["Good!",        1000],
    ["Nice!",        1001],
    ["Greate!",      1002],
    ["Fantastic!",   1003],
    ["Brilliant!",   1004],
    ["Incredible!",  1005],
    ["Perfect!",     1006],
    ["Absolutely!",  1007],
    ["Interesting!", 1008],
    ["Important!",   1009],
    ["Awesome!",     1010],
    ["Wonderful!",   1011],
    ["Amazing!",     1012],
    ["Cute!",        1013],
    ["Cool!",        1014],
    ["Clever!",      1015],
    ["Beautiful!",   1016],
    ["Useful!",      1017],

    ["Good lack!",       2000],
    ["Good job!",        2001],
    ["Good work!",       2002],
    ["Good story!",      2003],
    ["Sounds good!",     2004],
    ["Looks delicious!", 2005],
    ["Well done!",       2006],

    ["Not too bad.",         3000],
    ["Maybe another time.",  3001],
    ["Not realy.",           3002],
    ["Think header.",        3003],
    ["I do that too.",       3004],
    ["You should be sleep.", 3005],
    ["It must be true.",     3006],
    ["It should be true.",   3007],
    ["It can be true.",      3008],
    ["It could be true.",    3009],

    ["That's right!", 4000],
    ["I like it!",    4001],
    ["I love it!",    4002],
    ["I feel so.",    4003],
    ["I hope so.",    4004],
    ["I guess so.",   4005],
    ["I think so.",   4006],
    ["I suggest so.", 4007],

    ["What's happen?",      5000],
    ["What's wrong?",       5001],
    ["What's the matter?",  5002],
    ["Why not?",            5003],
    ["What are you doing?", 5004],
    ["Are you kidding?",    5005],
    ["What's going on?",    5006],

    ["Creepy!",                 6000],
    ["Awful!",                  6001],
    ["Scared!",                 6002],
    ["Not fair!",               6003],
    ["Too bad!",                6004],
    ["No good!",                6005],

    ["That's wrong.",           7000],
    ["I don't like it.",        7001],
    ["You shouldn't say that.", 7002],
    ["You shouldn't do that.",  7003],
  ]
  validates :evaluation, presence: true

end
