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
