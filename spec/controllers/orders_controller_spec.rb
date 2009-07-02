require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../app/controllers/orders_controller')

describe "adding discount codes in edit order screen" do
  controller_name :orders
  before(:each) do
    @variant = mock_model(Variant, :price => 10, :on_hand => 50)
    Variant.stub!(:find, :return => @variant)
    @order = Order.create
    @token = "TOKEN123"
    @order.token = @token
    @order.save
    
    @discount_code = Factory( :discount_code )

  end

  it "should not add a discount code when no code is provided" do
    @order.should_not_receive(:discount_code)
    put :update, "id" => @order.number,"code" => "", "order"=>{"line_item_attributes"=>{"2"=>{"quantity"=>"1"}}}
  end
  #but 
  it "should  add a discount code when a code is provided" do
    DiscountCode.should_receive(:find_by_code).with("#{@discount_code.code}")
    @order.should_receive(:discount_code=)
    put :update, "id" => @order.number, "code" => "#{@discount_code.code}", "order"=>{"line_item_attributes"=>{"2"=>{"quantity"=>"1"}}}
  end
  
end