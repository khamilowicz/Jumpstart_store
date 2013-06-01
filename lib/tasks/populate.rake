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
      admin: true
      )

    25.times do 
      Product.create!(
        title: Faker::Lorem.sentence(rand(4)+1),
        description: Faker::Lorem.paragraph(3),
        base_price: "#{rand(100)}.#{rand(100)}",
        discount: 100,
        quantity: rand(20),
        on_sale: true
        )
    end

    4.times do
      User.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email, 
        password: Faker::Lorem.word 
        )
    end

    2.times do 
      Category.create!(
        name: "Category #{Faker::Lorem.word}"
        )
    end 

    Category.all.each do |category|
      Product.all.sample(6).each do |product|
        category.add_product product
      end
    end

    User.all.each do |user|
      Product.all.sample(rand(8)).each do |product|
        user.add_product product
      end
    end
  end
end