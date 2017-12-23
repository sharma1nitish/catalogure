AdminUser.create!(email: 'admin@catalogure.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')

1.upto(9) do |i|
  category = Category.create!(name: "category #{i}")

  1.upto(2) do |j|
    sub_category = category.children.create!(name: "sub_category #{i}.#{j}")

    1.upto(3) do |k|
      sub_sub_category = sub_category.children.create!(name: "sub_sub_category #{i}.#{j}.#{k}")
      Product.create!(categories: [sub_sub_category], name: "product #{i}.#{j}.#{k}", description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100)) if k.even?
    end
  end
end

