
# :user symbol lets rspec know that this factory should use the "users" model
Factory.define :user do |user|
    user.name                     "Julio Terra"
    user.email                    "julioterra@example.com"
    user.password                 "badabing"
    user.password_confirmation    "badabing"
end

Factory.sequence :email do |n|
    "person-#{n}@example.com"
end