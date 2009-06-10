class AddColumnsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :discount_code_id, :integer
    add_column :orders, :discount_total, :float
    add_column :orders, :commission_total, :float
  end

  def self.down
  end
end