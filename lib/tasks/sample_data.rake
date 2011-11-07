require 'faker'

namespace :db do
    desc "Fill database with sample data to test functionality"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke
        admin = User.create! name: "Albert Einstein",
                     email: "albert@einstein.com",
                     password: "emcsquared",
                     password_confirmation: "emcsquared"
        admin.toggle!(:admin)            

        120.times do |n|
            name = Faker::Name.name
            email = "albert-#{n+1}@einstein.com"
            password = "password"
            User.create! :name => name,
                         :email => email,
                         :password => password,
                         :password_confirmation => password
        end

        User.all(limit: 6).each do |user|
            50.times do
                user.microposts.create!(content: Faker::Lorem.sentence(5))
            end
        end

    end
end