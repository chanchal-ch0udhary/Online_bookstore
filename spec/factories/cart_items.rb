FactoryBot.define do
  factory :cart_item do
    association :cart
    association :book
    quantity { 1 }
  end
end
