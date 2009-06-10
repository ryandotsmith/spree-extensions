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
    before_filter :add_discount_code_fields
    after_filter :bulid_discount_code, :only => [:new,:edit]

      def add_discount_code_fields
        @extension_partials << 'discount_codes'
      end

      def bulid_discount_code
        @user.discount_codes.build
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
    
    Order.class_eval do
      belongs_to :discount_code      
#      def initialize
#         require "rubygems"; require "ruby-debug"; debugger 
#         super
#      end

     # def total
     #   self.total = self.item_total + self.ship_amount + self.tax_amount - self.calculate_discount
     # end

      def update_totals
        # finalize order totals 
        unless shipment.nil?
          calculator = shipment.shipping_method.shipping_calculator.constantize.new
          self.ship_amount = calculator.calculate_shipping(shipment) 
        else
          self.ship_amount = 0
        end
        self.tax_amount       = calculate_tax
        #self.discount_total   = calculate_discount
        #self.commission_total = calculate_commission
      end

      def calculate_discount
        self.item_total * self.discount_code.discount_rate 
      end

      def calculate_commission
        self.item_total * self.discount_code.commission_rate
      end
      
    end#class_eval
    
  end #activate 
end# class extension
