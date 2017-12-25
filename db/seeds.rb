AdminUser.create!(email: 'admin@catalogure.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')

category = Category.create!(name: 'Books')

sub_category = category.children.create!(name: 'Genre')

fantasy = sub_category.children.create!(name: 'Fantasy')
horror = sub_category.children.create!(name: 'Horror')
mystery = sub_category.children.create!(name: 'Mystery')
romance = sub_category.children.create!(name: 'Romance')

sub_category = category.children.create!(name: 'Author')

rowling = sub_category.children.create!(name: 'J. K. Rowling')
king = sub_category.children.create!(name: 'Stephen King')
brown = sub_category.children.create!(name: 'Dan Brown')
segal = sub_category.children.create!(name: 'Erich Segal')

category = Category.create!(name: 'Clothing')

sub_category = category.children.create!(name: 'Material')

cotton = sub_category.children.create!(name: 'Cotton')
polyester = sub_category.children.create!(name: 'Polyester')
denim = sub_category.children.create!(name: 'Denim')
leather = sub_category.children.create!(name: 'Leather')

sub_category = category.children.create!(name: 'Type')

shirt = sub_category.children.create!(name: 'T Shirt')
trousers = sub_category.children.create!(name: 'Trousers')
shorts = sub_category.children.create!(name: 'Shorts')
jackets = sub_category.children.create!(name: 'Jackets')

category = Category.create!(name: 'Movies')

sub_category = category.children.create!(name: 'Genre')

action = sub_category.children.create!(name: 'Action')
fiction = sub_category.children.create!(name: 'Science Fiction')
drama = sub_category.children.create!(name: 'Drama')
documentary = sub_category.children.create!(name: 'Documentary')

sub_category = category.children.create!(name: 'Language')

english = sub_category.children.create!(name: 'English')
french = sub_category.children.create!(name: 'French')
german = sub_category.children.create!(name: 'German')
spanish = sub_category.children.create!(name: 'Spanish')

category = Category.create!(name: 'Laptops')

sub_category = category.children.create!(name: 'Brand')

apple = sub_category.children.create!(name: 'Apple')
dell = sub_category.children.create!(name: 'Dell')
lenovo = sub_category.children.create!(name: 'Lenovo')
hp = sub_category.children.create!(name: 'HP')

sub_category = category.children.create!(name: 'Screen')

inch_11 = sub_category.children.create!(name: '11 inch')
inch_12 = sub_category.children.create!(name: '12 inch')
inch_13 = sub_category.children.create!(name: '13 inch')
inch_15 = sub_category.children.create!(name: '15 inch')

# Books

Product.create!(categories: [fantasy, rowling], name: 'Harry Potter anf the Prisoner of Azkaban', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [mystery, rowling], name: "The Cuckoo's Calling", description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [horror, king], name: 'The Shining', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [horror, mystery, king], name: 'The Mist', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [mystery, brown], name: 'Angels and Demons', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [romance, segal], name: 'Love Story', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))

# Clothing

Product.create!(categories: [cotton, shirt], name: 'Cotton T Shirt', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [cotton, trousers], name: 'Cotton Trousers', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [cotton, shorts], name: 'Cotton Shorts', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [polyester, shirt], name: 'Polyester T Shirt', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [polyester, trousers], name: 'Polyester Trousers', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [polyester, shorts], name: 'Polyester Shorts', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [denim, jackets], name: 'Denim Jacket', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [denim, trousers], name: 'Denim Trousers', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [denim, shorts], name: 'Denim Shorts', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [leather, jackets], name: 'Leather Jacket', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [leather, trousers], name: 'Leather Pants', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))

# Movies

Product.create!(categories: [action, english], name: 'Die Hard', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [drama, english], name: 'Silver Lining Playbook', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [drama, french], name: "Paris Je T'aime", description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [drama, german], name: 'Die Welle', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [fiction, german], name: 'The Tunnel', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [documentary, english], name: 'Bowling for Columbine', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))

# Laptops

Product.create!(categories: [apple, inch_11], name: 'Apple 11 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [apple, inch_12], name: 'Apple 12 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [apple, inch_13], name: 'Apple 13 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [apple, inch_15], name: 'Apple 15 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [dell, inch_11], name: 'Dell 11 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [dell, inch_12], name: 'Dell 12 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [dell, inch_13], name: 'Dell 13 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [dell, inch_15], name: 'Dell 15 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [lenovo, inch_11], name: 'Lenovo 11 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [lenovo, inch_12], name: 'Lenovo 12 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [lenovo, inch_13], name: 'Lenovo 13 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [lenovo, inch_15], name: 'Lenovo 15 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [hp, inch_11], name: 'HP 11 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [hp, inch_12], name: 'HP 12 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [hp, inch_13], name: 'HP 13 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
Product.create!(categories: [hp, inch_15], name: 'HP 15 inch', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))

