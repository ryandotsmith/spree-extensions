class TftExtension < Spree::Extension
  version "1.0"
  description "Extensions for New Leaf Paper"
  url "http://thinkfasttank.com"

  def self.require_gems(config)
    config.gem "thoughtbot-factory_girl",
               :lib    => "factory_girl",
               :source => "http://gems.github.com"
  end  

  def activate

    Admin::UsersController.class_eval do
      # when editing a user, we need to build a dc object in case the user wants to
      # add a new discount code to the user. We are not using fields for on the user 
      # because we have the discount code in a seperate field and when you update a user 
      # and you do not supply a role, all roles get deleted. 
      edit.before do
        @discount_code = DiscountCode.new
      end
    end

    Admin::ConfigurationsController.class_eval do
      before_filter :add_discount_codes_links, :only => :index
      def add_discount_codes_links
        @extension_links << {
                              :link => admin_discount_codes_url, 
                              :link_text => 'Discount Codes', 
                              :description => "Manage affiliates and their discount codes." }
      end#def
    end#class_eval

    User.class_eval do
      has_many :discount_codes
      accepts_nested_attributes_for :discount_codes, 
        :allow_destroy => true, 
        :reject_if => proc { |attributes| attributes["comments"].blank? }
      attr_accessible :discount_codes_attributes
      include Affiliate
    end
    #######################
    # The Order gets by with a little help from friends
    Order.class_eval do
      belongs_to :discount_code      

     def total
       self.total = self.item_total + self.ship_amount + self.tax_amount - self.calculate_discount
     end

      def update_totals
        # finalize order totals 
        unless shipment.nil?
          calculator = shipment.shipping_method.shipping_calculator.constantize.new
          self.ship_amount = calculator.calculate_shipping(shipment) 
        else
          self.ship_amount = 0
        end
        self.tax_amount       = calculate_tax
        self.discount_total   = calculate_discount
        self.commission_total = calculate_commission
      end
      # this method is used in the view to display
      # the total of all items after discount ( if any )
      def discounted_item_total
        ( self.item_total - self.discountable_item_total )
      end
      # using this method to calculate which items that we can discount. 
      def discountable_item_total
        tot = 0
        self.line_items.each do |li|
          tot += li.total if li.product.taxons.any? {|t| t.name == "Discountable"}
        end
        self.item_total = tot
      end

      def calculate_discount
        return 0.0 if self.discount_code.nil?
        self.discountable_item_total * self.discount_code.discount_rate
      end

      def calculate_commission
        return 0.0 if self.discount_code.nil?
        self.item_total * self.discount_code.commission_rate
      end
      
    end#class_eval
    
  end #activate 
end# class extension
