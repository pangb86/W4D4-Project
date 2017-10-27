class User < ApplicationRecord
  validates :username, :session_token, presence:true, uniqueness:true
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}

  after_initialize :ensure_session_token

  attr_reader :password


  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    self.save
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    #creates a bcrypt object, but it's saved as a string in the db
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    #bcrypt password.new is accepting a string from db and turns back into bcrypt object
    pass_hash = BCrypt::Password.new(self.password_digest)
    #calling built in is_password method from bcrypt which hashes input password and compares with pass_hash
    pass_hash.is_password?(password)
  end

  def self.find_by_credentials(username,password)
    @user = User.find_by(username: username)
    return nil if @user.nil?
    @user.is_password?(password) ? @user : nil
  end

end
