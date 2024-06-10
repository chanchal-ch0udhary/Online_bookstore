FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book Title #{n}" }
    author { "Author Name" }
    description { "Book Description" }
    price { 19.99 }
    stock_quantity { 10 }
  end
end