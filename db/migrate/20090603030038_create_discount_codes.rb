class CreateDiscountCodes < ActiveRecord::Migration
  def self.up
    create_table :discount_codes do |t|
      t.float :discount_rate, :default => 1.0
      t.float :commission_rate, :default => 1.0
      t.text :comments
      t.integer :user_id
      t.string :code
      t.datetime :expires_on
      t.timestamps
    end
  end

  def self.down
    drop_table :discount_codes
  end
end
