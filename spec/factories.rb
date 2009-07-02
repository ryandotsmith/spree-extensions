Factory.sequence :login do |n|
  "user#{n}"
end

Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |u|
  u.login                 { Factory.next :login }
  u.password              { "password" }
  u.password_confirmation { "password" }
  u.email                 { Factory.next :email }
end

Factory.define :discount_code do |dc|
  dc.comments           { "partna!!!" }
  dc.commission_rate    { 0.10 }
  dc.discount_rate      { 0.30 }
  dc.association :user, :factory => :user 
end

Factory.define :order do |order|
  order.number      { "12345" }
  order.association :user, :factory => :user
  order.association :discount_code, :factory => :discount_code
end

Factory.define :taxon do |taxon|
  taxon.taxonomy_id { 1 }
  taxon.name        { "discountable" }
end

Factory.define :product do |product|
  product.name          { "widget" }
  product.description   { "does anything or nothing" }
  product.master_price  { 10000 }
end

Factory.define :line_item do |line_item|
  line_item.association :order, :factory => :order
  line_item.price       { 10.00 }
end

Factory.define :variant do |variant|
  variant.association :product, :factory => :product
end



