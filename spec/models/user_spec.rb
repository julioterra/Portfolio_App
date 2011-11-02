require 'spec_helper'

describe User do
  
  before (:each) do
    @attr = {name: "Julio Terra", 
             email: "juliot@jt.com",
             password: "testing",
             password_confirmation: "testing"}
    
  end
  
  it "should create a new record given valid information" do
    User.create!(@attr)
  end

    describe "password validations: " do

        before (:each) do
          email = "shufflenamehere".split('').shuffle.join + "@gmail.com"
          @attr.merge(email: email)
          @user = User.create!(@attr)
        end
      
        it "should require a password" do
            User.new(@attr.merge(password:"", password_confirmation: ""))
            should_not be_valid
        end
        
        it "should require password match confirmation" do
            User.new(@attr.merge(password_confirmation: "invalid"))
            should_not be_valid
        end
        
        it "should reject short passwords" do
            short = 'a' * 5
            User.new(@attr.merge(password: short, password_confirmation: short ))
            should_not be_valid
        end

        it "should reject long passwords" do
            long = 'a' * 41
            User.new(@attr.merge(password: long, password_confirmation: long ))
            should_not be_valid
        end
        
        it "encrypted password should not be blank" do
            @user.encrypted_password.should_not be_blank
        end
        
        it "should have an encrypted password attribute" do
            @user.should respond_to(:encrypted_password)
        end

        describe "password encryption method functions: " do        
          
            it "should be true if passwords match" do
                @user.has_password?(@attr[:password]).should be_true
            end
            
            it "should be false if passwords don't match" do
                @user.has_password?("invalid").should be_false
            end

            describe "authenticate method functions: " do        
              
                it "should not work if the email is not valid" do
                    wrong_password_user = User.authenticate("invalid password", @attr[:password])
                    wrong_password_user.should be_nil
                end

                it "should not work if the email and password combination is not valid " do
                    wrong_password_user = User.authenticate(@attr[:email], "invalid_pass")
                    wrong_password_user.should be_nil
                end

                it "should work if the email and password are correct" do
                  wrong_password_user = User.authenticate(@attr[:email], @attr[:password])
                  wrong_password_user.should == @user
                end

            end
        end        
    end



    describe "name validations " do
        it "should require a name" do
          no_name_user = User.new(@attr.merge(name:""))
          no_name_user.should_not be_valid
        end

        it "should reject names longer than 50 characters" do
          long_name = "l" * 51
          no_name_user = User.new(@attr.merge(name:long_name))
          no_name_user.should_not be_valid
        end
    end
    


    describe "email validations " do
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
    
    describe "admin attribute" do
      before(:each) do
          @user = User.create!(@attr)
      end
      
      it "should respond to admin" do
        @user.should respond_to(:admin)
      end

      it "should not be an admin by default" do
        @user.should_not be_admin
      end

      it "should not convertible to admin" do
        @user.toggle!(:admin)
        @user.should be_admin
      end
      
    end
    
end
