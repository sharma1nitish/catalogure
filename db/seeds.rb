AdminUser.create!(email: 'admin@catalogure.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')

category = Category.create!(name: 'Books')

sub_category = category.children.create!(name: 'Genre')

sub_sub_category = sub_category.children.create!(name: 'Fantasy')
sub_sub_category = sub_category.children.create!(name: 'Horror')
sub_sub_category = sub_category.children.create!(name: 'Mystery')
sub_sub_category = sub_category.children.create!(name: 'Romance')

sub_category = category.children.create!(name: 'Author')

sub_sub_category = sub_category.children.create!(name: 'J. K. Rowling')
sub_sub_category = sub_category.children.create!(name: 'Stephen King')
sub_sub_category = sub_category.children.create!(name: 'Dan Brown')
sub_sub_category = sub_category.children.create!(name: 'Erich Segal')

category = Category.create!(name: 'Clothing')

sub_category = category.children.create!(name: 'Material')

sub_sub_category = sub_category.children.create!(name: 'Cotton')
sub_sub_category = sub_category.children.create!(name: 'Polyester')
sub_sub_category = sub_category.children.create!(name: 'Denim')
sub_sub_category = sub_category.children.create!(name: 'Leather')

sub_category = category.children.create!(name: 'Type')

sub_sub_category = sub_category.children.create!(name: 'T Shirt')
sub_sub_category = sub_category.children.create!(name: 'Trouser')
sub_sub_category = sub_category.children.create!(name: 'Shorts')
sub_sub_category = sub_category.children.create!(name: 'Jackets')

category = Category.create!(name: 'Movies')

sub_category = category.children.create!(name: 'Genre')

sub_sub_category = sub_category.children.create!(name: 'Action')
sub_sub_category = sub_category.children.create!(name: 'Science Fiction')
sub_sub_category = sub_category.children.create!(name: 'Drama')
sub_sub_category = sub_category.children.create!(name: 'Documentary')

sub_category = category.children.create!(name: 'Language')

sub_sub_category = sub_category.children.create!(name: 'English')
sub_sub_category = sub_category.children.create!(name: 'French')
sub_sub_category = sub_category.children.create!(name: 'German')
sub_sub_category = sub_category.children.create!(name: 'Spanish')

category = Category.create!(name: 'Laptops')

sub_category = category.children.create!(name: 'Brand')

sub_sub_category = sub_category.children.create!(name: 'Apple')
sub_sub_category = sub_category.children.create!(name: 'Dell')
sub_sub_category = sub_category.children.create!(name: 'Lenovo')
sub_sub_category = sub_category.children.create!(name: 'HP')

sub_category = category.children.create!(name: 'Screen')

sub_sub_category = sub_category.children.create!(name: '11 inch')
sub_sub_category = sub_category.children.create!(name: '12 inch')
sub_sub_category = sub_category.children.create!(name: '13 inch')
sub_sub_category = sub_category.children.create!(name: '15 inch')

