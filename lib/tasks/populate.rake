namespace :db do 
  desc 'Erase and fill database'
  task :populate => :environment do
    require 'faker'

    Rake::Task['db:reset'].invoke

    admin = User.create!(
      first_name: "Kham",
      last_name: "Khamilowicz",
      email: 'kham@gmail.com',
      password: 'megamega',
      password_confirmation: 'megamega',
      )
    admin.promote_to_admin
    admin.save

    40.times do 
      Product.create!(
        title: Faker::Lorem.sentence(rand(4)+1),
        description: Faker::Lorem.paragraph(3),
        base_price: Money.new(rand(10000), "USD"),
        discount: 100,
        quantity: rand(20),
        on_sale: true
        )
    end

    4.times do
      password = Faker::Lorem.word
      User.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email, 
        password: password,
        password_confirmation: password
        )
    end

    5.times do 
      Category.create!(
        name: "#{Faker::Lorem.word}"
        )
    end 

    Category.all.each do |category|
      Product.all.sample(11).each do |product|
        category.add product: product
      end
    end

    User.all.each do |user|
      Product.all.sample(rand(8)).each do |product|
        user.add product: product
      end
    end
  end
end