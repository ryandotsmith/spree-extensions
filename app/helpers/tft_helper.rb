module TftHelper
  def discount_price(order, options={})
    options.assert_valid_keys(:format_as_currency, :show_vat_text, :show_price_inc_vat)
    options.reverse_merge! :format_as_currency => true, :show_vat_text => true
  
    # overwrite show_vat_text if show_price_inc_vat is false
    options[:show_vat_text] = Spree::Tax::Config[:show_price_inc_vat]

    amount =  order.item_total    
    amount += Spree::VatCalculator.calculate_tax(order) if Spree::Tax::Config[:show_price_inc_vat]    
    amount -= order.calculate_discount
    options.delete(:format_as_currency) ? number_to_currency(amount) : amount
  end
end