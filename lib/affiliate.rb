module Affiliate

  def is_affiliate?
    DiscountCode.all.any? { |code| code.user_id == self.id }
  end
  
end
