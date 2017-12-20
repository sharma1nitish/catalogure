AdminUser.create!(email: 'admin@catalogure.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe') if Rails.env.development?

1.upto(10) do |i|
  category = Category.create!(name: "category #{i}")

  1.upto(2) do |j|
    sub_category = category.children.create!(name: "sub_category #{i}.#{j}")

    1.upto(3) do |k|
      sub_sub_category = sub_category.children.create!(name: "sub_sub_category #{i}.#{j}.#{k}")
      sub_sub_category.products.create!(name: "product #{i}.#{j}.#{k}", price_in_sgd: rand(1..100)) if k.even?
    end
  end
end

