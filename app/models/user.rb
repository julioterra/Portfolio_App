class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,      presence:       true,
                        length:         { :maximum => 50 }
  validates :email,     presence:       true,
                        format:         { :with => email_regex },
                        uniqueness:     { :case_sensitive => false }
  validates :password,  presence:       true,
                        confirmation:   true,
                        length:         { :within => 6..40 }

  before_save :encrypt_password

  # ~~~~~~~~~~~~~~~~
  # class methods
  def self.authenticate(submitted_email, submitted_password)
    user = find_by_email(submitted_email)
    return nil if (user == nil) 
    return user if user.has_password?(submitted_password) 
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    # if the user exists and the user's salt equals the cookie_salt then return the user
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  
  # ~~~~~~~~~~~~~~~~
  # instance methods
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  private
    def encrypt_password 
      self.salt = make_salt if new_record?           #create salt if this is a new record
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")    
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
    
end
