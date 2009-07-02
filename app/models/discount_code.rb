class DiscountCode < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  def before_save
    self.code ||= generate_code()
  end
  
  def generate_code(code_length=6)
    chars = ("a".."z").to_a + ("1".."9").to_a
    new_code = Array.new(code_length, '').collect{chars[rand(chars.size)]}.join
    Digest::MD5.hexdigest(new_code)[0..(code_length-1)].upcase
  end

  def generate_unique_code
    begin
      new_code = generate_code(self.code_length)
    end until !active_code?( new_code )
    new_code
  end
  
  # Checks the database to ensure the specified code is not taken
  def active_code?( code )
    find :first, :conditions => { :code => code }
  end

  def expired?
    DateTime.now > expires_on
  end

end
