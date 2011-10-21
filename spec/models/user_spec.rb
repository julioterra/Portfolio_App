require 'spec_helper'

describe User do
  
  before (:each) do
    @attr = {name: "Julio Terra", email: "jujuba@gmail.com"}
  end
  
  it "should create a new record given valid information" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(name:""))
    no_name_user.should_not be_valid
  end

  it "should reject names longer than 50 characters" do
    long_name = "l" * 51
    no_name_user = User.new(@attr.merge(name:long_name))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_name_user = User.new(@attr.merge(email:""))
    no_name_user.should_not be_valid
  end

  it "should accept valid emails" do
    address = %w[foo@boo.org fooboo.boo@loo.go.bo FOOBOO@lootoo.doo]
    address.each do |cur_e|
      no_name_user = User.new(@attr.merge(email:cur_e))
      no_name_user.should be_valid
    end
  end

  it "should reject invalid emails" do
    address = %w[foo@boo.org. fooboo.boo@loo gooboo.doo jooodooo@]
    address.each do |cur_e|
      no_name_user = User.new(@attr.merge(email:cur_e))
      no_name_user.should_not be_valid
    end
  end

  it "should not accept duplicate emails" do
    user_upcase = @attr.merge(email: @attr[:email].upcase)
    User.create!(user_upcase)                       #create user with an email to test against
    user_with_same_email = User.new(user_upcase)    #create second user with same email
    user_with_same_email.should_not be_valid        #second user should not be valid
  end

end
