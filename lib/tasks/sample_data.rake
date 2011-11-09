#require 'faker'

namespace :db do
    desc "Fill database with sample data to test functionality"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke
        make_users
        make_microposts
        make_relationships
    end
end

def make_users
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
end

def make_microposts
  User.all(limit: 6).each do |user|
      50.times do
          user.microposts.create!(content: Faker::Lorem.sentence(5))
      end
  end
end

def make_relationships
  users = User.all
  user = user.first
  following = users [1..50]
  followers = users [3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
