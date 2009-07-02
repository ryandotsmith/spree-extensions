# Affiliate System #
works with 0.8.3 only

## extensions
This extension creates a DiscountCode resource. 
	discount_code belongs_to :user 
	order has_many :discount_codes

We also will add some columns to the Order model. 
	order.discount_code_id
	order.discount_total => once the discount is calculated it is stored on the order 
	order.commission_total => likewise 

The methods added:
	order.calculate_discount
	order.calculate_commission

## theory

A user can become an affiliate by adding a discount_code. 
  @user.is_affilliate? 

Not all products are created equal. When the discount_total is calculated, the method only considers 
products that have a taxon with a name == "Discountable"

