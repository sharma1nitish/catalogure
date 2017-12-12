AdminUser.create!(email: 'admin@catalogure.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe') if Rails.env.development?

10.times { Product.create!(name:  FFaker::Product.product, price_in_sgd: rand(1..100)) }
