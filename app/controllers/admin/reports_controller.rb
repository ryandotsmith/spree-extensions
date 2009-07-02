class Admin::ReportsController < Admin::BaseController
  before_filter :load_data  
  
  AVAILABLE_REPORTS = {
    :sales_total    => {:name => "Sales Total", :description => "Sales Total For All Orders"},
    :discount_codes => {:name => "Discount Codes", :description => "View Discount Codes and Their activity"}

  }

  def index
    @reports = AVAILABLE_REPORTS
  end
  
  def sales_total

    @search = Order.new_search(params[:search])
    #set order by to default or form result
    @search.order_by ||= :created_at
    @search.order_as ||= "DESC"
    
    @orders = @search.find(:all)    

    @item_total = @search.sum(:item_total)
    @ship_total = @search.sum(:ship_amount)
    @tax_total = @search.sum(:tax_amount)
    @sales_total = @search.sum(:total)
  end

  def discount_codes
    @search = DiscountCode.new_search( params[:search] )
    @discount_codes = @search.find(:all)    
  end
  
  def discount_code_orders
    @discount_code = DiscountCode.find( params[:discount_code] )
    @orders = @discount_code.orders
  end

private 
  def load_data

  end  

end