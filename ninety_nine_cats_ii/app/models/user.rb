# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :user_name, :session_token, presence: true, uniqueness: true 
  validates :password_digest, presence: { message: 'Password can\'t be blank'}  
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token
   
  attr_reader: :password 
  
  def password=(pw)
    @password = pw 
    self.password_digest = BCrypt::Password.create(pw)
  end 
  
  def is_password?(pw)
    Bcrypt::Password.new(self.password_digest).is_password?(pw)
  end
  
  def self.find_by_credentials(user_name, password)
    u = User.find_by(user_name: user_name)
    return u if u && u.is_password?(password)
    nil 
  end
    
  def ensure_session_token
    self.session_token ||= User.generate_session_token 
  end 

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end
  
  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end
end
