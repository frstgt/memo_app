class User < ApplicationRecord

  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 32 },
                    uniqueness: true

  has_secure_password
  VALID_PASSWORD_REGEX = /(?=.*\d+.*)(?=.*[a-z]+.*)(?=.*[A-Z]+.*).*[\-\+\/\*\%\^\&\|\~\<\=\>\"\'\`\;\:\[\]\{\}\(\)\!\?\@\#\$\,\.\_\\]+.*/
  validates :password, presence: true,
                       length: { minimum: 16, maximum: 64 },
                       format: { with: VALID_PASSWORD_REGEX },
                       allow_nil: true

end
