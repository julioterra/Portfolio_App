require 'faker'

namespace :db do
    desc "Fill database with sample data to test functionality"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke
        User.create! name: "Albert Einstein",
                     email: "albert@einstein.com",
                     password: "emcsquared",
                     password_confirmation: "emcsquared"
        199.times do |n|
            name = Faker::Name.name
            email = "albert-#{n+1}@einstein.com"
            password = "password"
            User.create! :name => name,
                         :email => email,
                         :password => password,
                         :password_confirmation => password
        end
    end
end